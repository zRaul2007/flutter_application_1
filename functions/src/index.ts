import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

/**
 * Função HTTP acionada pelo Node-RED para enviar um alerta.
 * Exemplo de chamada: POST https://.../sendPetAlert
 * Corpo (Body) da requisição (JSON):
 * {
 * "petId": "ID_DO_PET",
 * "title": "Alerta de Temperatura!",
 * "body": "A temperatura do Bolacha está muito alta: 40.5°C"
 * }
 */
export const sendPetAlert = functions.https.onRequest(async (request, response) => {
    // Valida que a requisição é do tipo POST
    if (request.method !== "POST") {
        response.status(405).send("Method Not Allowed");
        return;
    }

    const { petId, title, body } = request.body;

    if (!petId || !title || !body) {
        response.status(400).send("Faltando parâmetros: petId, title ou body.");
        return;
    }

    try {
        // 1. Encontrar o dono do pet
        const petDoc = await db.collection("pets").doc(petId).get();
        if (!petDoc.exists) {
            response.status(404).send(`Pet com ID ${petId} não encontrado.`);
            return;
        }
        const ownerId = petDoc.data()?.ownerId;

        // 2. Encontrar o token do dispositivo do dono
        const userDoc = await db.collection("users").doc(ownerId).get();
        if (!userDoc.exists) {
            response.status(404).send(`Dono com ID ${ownerId} não encontrado.`);
            return;
        }
        const fcmToken = userDoc.data()?.fcmToken;

        if (!fcmToken) {
            response.status(500).send(`Token FCM para o dono ${ownerId} não encontrado.`);
            return;
        }

        // 3. Montar a notificação
        const payload: admin.messaging.Message = {
            token: fcmToken,
            notification: {
                title: title,
                body: body,
            },
            // Você pode adicionar dados extras para serem usados no app
            data: {
                petId: petId,
                click_action: "FLUTTER_NOTIFICATION_CLICK", // Padrão para apps Flutter
            },
        };

        // 4. Enviar a notificação
        await messaging.send(payload);

        response.status(200).send("Notificação enviada com sucesso!");
    } catch (error) {
        console.error("Erro ao enviar notificação:", error);
        response.status(500).send("Erro interno ao processar a requisição.");
    }
});