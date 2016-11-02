module.exports = {
	logs		: true,
	key			: 'ruta privkey letsencrypt',
	certificate	: 'ruta certificado letsencrypt',
	answers		: ["A", "B", "C", "D"],
	host		: '127.0.0.1',
	user     	: 'user',
	password 	: "*****",
	database 	: 'nombre',
	botTelegram	: {	bot:{id: 'id_bot', name: 'nombre_bot' },
					serviceUrl: 'https://telegram.botframework.com',
					useAuth: true }
};