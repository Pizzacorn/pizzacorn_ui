// Ejemplo para integrar en el proyecto Firebase Functions de la aplicación.
const { onRequest } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.sendNotification = onRequest(
  {
    allowUnauthenticated: true,
    region: 'europe-west1',
  },
  async (req, res) => {
    if (req.method !== 'POST') {
      return res.status(405).send('Método no permitido');
    }

    const { title, body, topic = 'all', type, relatedId, extraData = {} } =
      req.body || {};

    if (
      typeof title !== 'string' || !title.trim() ||
      typeof body !== 'string' || !body.trim() ||
      typeof topic !== 'string' || !topic.trim() ||
      typeof type !== 'string' || !type.trim() ||
      typeof relatedId !== 'string' ||
      !extraData || Array.isArray(extraData) || typeof extraData !== 'object'
    ) {
      return res.status(400).json({ error: 'Payload de notificación inválido' });
    }

    try {
      const messageId = await admin.messaging().send({
        notification: { title, body },
        data: {
          type,
          relatedId,
          extraData: JSON.stringify(extraData),
        },
        topic,
      });
      return res.status(200).json({ success: true, messageId });
    } catch (error) {
      console.error('Error en FCM:', error);
      return res.status(500).json({ error: error.message });
    }
  },
);
