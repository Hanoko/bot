-- MySQL dump 10.13  Distrib 5.7.16, for Linux (x86_64)
--
-- Host: localhost    Database: pablobot
-- ------------------------------------------------------
-- Server version	5.7.16-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `answerhistory`
--

DROP TABLE IF EXISTS `answerhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answerhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` int(11) DEFAULT NULL,
  `quiz` int(11) DEFAULT NULL,
  `user` varchar(45) DEFAULT NULL,
  `result` enum('right','wrong') DEFAULT NULL,
  `data` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answerhistory`
--

LOCK TABLES `answerhistory` WRITE;
/*!40000 ALTER TABLE `answerhistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `answerhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `callback_query`
--

DROP TABLE IF EXISTS `callback_query`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `callback_query` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Unique identifier for this query.',
  `user_id` char(20) DEFAULT NULL COMMENT 'Sender',
  `message` text COMMENT 'Message',
  `inline_message_id` char(255) DEFAULT NULL COMMENT 'Identifier of the message sent via the bot in inline mode, that originated the query',
  `data` char(255) NOT NULL DEFAULT '' COMMENT 'Data associated with the callback button.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `callback_query_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `callback_query`
--

LOCK TABLES `callback_query` WRITE;
/*!40000 ALTER TABLE `callback_query` DISABLE KEYS */;
/*!40000 ALTER TABLE `callback_query` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat`
--

DROP TABLE IF EXISTS `chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat` (
  `id` char(20) NOT NULL DEFAULT '0' COMMENT 'Unique user or chat identifier',
  `type` enum('private','group','supergroup','channel') NOT NULL COMMENT 'chat type private, group, supergroup or channel',
  `title` char(255) DEFAULT '' COMMENT 'chat title null if case of single chat with the bot',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date update',
  `old_id` bigint(20) DEFAULT NULL COMMENT 'Unique chat identifieri this is filled when a chat is converted to a superchat',
  PRIMARY KEY (`id`),
  KEY `old_id` (`old_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat`
--

LOCK TABLES `chat` WRITE;
/*!40000 ALTER TABLE `chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `chat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chosen_inline_query`
--

DROP TABLE IF EXISTS `chosen_inline_query`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chosen_inline_query` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for chosen query.',
  `result_id` char(255) NOT NULL DEFAULT '' COMMENT 'Id of the chosen result',
  `user_id` char(20) DEFAULT NULL COMMENT 'Sender',
  `location` char(255) DEFAULT NULL COMMENT 'Location object, senders''s location.',
  `inline_message_id` char(255) DEFAULT NULL COMMENT 'Identifier of the message sent via the bot in inline mode, that originated the query',
  `query` char(255) NOT NULL DEFAULT '' COMMENT 'Text of the query',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `chosen_inline_query_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chosen_inline_query`
--

LOCK TABLES `chosen_inline_query` WRITE;
/*!40000 ALTER TABLE `chosen_inline_query` DISABLE KEYS */;
/*!40000 ALTER TABLE `chosen_inline_query` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conversation`
--

DROP TABLE IF EXISTS `conversation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conversation` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Row unique id',
  `user_id` char(20) DEFAULT NULL COMMENT 'User id',
  `chat_id` char(20) DEFAULT NULL COMMENT 'Telegram chat_id can be a the user id or the chat id ',
  `status` enum('active','cancelled','stopped') NOT NULL DEFAULT 'active' COMMENT 'active conversation is active, cancelled conversation has been truncated before end, stopped conversation has end',
  `command` varchar(160) DEFAULT '' COMMENT 'Default Command to execute',
  `notes` varchar(1000) DEFAULT 'NULL' COMMENT 'Data stored from command',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date update',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `chat_id` (`chat_id`),
  KEY `status` (`status`),
  CONSTRAINT `conversation_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `conversation_ibfk_2` FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conversation`
--

LOCK TABLES `conversation` WRITE;
/*!40000 ALTER TABLE `conversation` DISABLE KEYS */;
/*!40000 ALTER TABLE `conversation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grades`
--

DROP TABLE IF EXISTS `grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grades` (
  `voice_id` int(11) NOT NULL,
  `user_id` char(20) NOT NULL,
  `grade` tinyint(4) DEFAULT NULL,
  `sent` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`voice_id`,`user_id`),
  KEY `grades_ibfk_2` (`user_id`),
  CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`voice_id`) REFERENCES `voice` (`voice_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grades`
--

LOCK TABLES `grades` WRITE;
/*!40000 ALTER TABLE `grades` DISABLE KEYS */;
/*!40000 ALTER TABLE `grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inline_query`
--

DROP TABLE IF EXISTS `inline_query`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inline_query` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Unique identifier for this query.',
  `user_id` char(20) DEFAULT NULL COMMENT 'Sender',
  `location` char(255) DEFAULT NULL COMMENT 'Location of the sender',
  `query` char(255) NOT NULL DEFAULT '' COMMENT 'Text of the query',
  `offset` char(255) NOT NULL DEFAULT '' COMMENT 'Offset of the result',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `inline_query_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inline_query`
--

LOCK TABLES `inline_query` WRITE;
/*!40000 ALTER TABLE `inline_query` DISABLE KEYS */;
/*!40000 ALTER TABLE `inline_query` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `message` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique message identifier',
  `chat_id` char(20) NOT NULL DEFAULT '0' COMMENT 'Chat identifier.',
  `user_id` char(20) DEFAULT NULL COMMENT 'User identifier',
  `date` timestamp NULL DEFAULT NULL COMMENT 'Date the message was sent in timestamp format',
  `forward_from` char(20) DEFAULT NULL COMMENT 'User id. For forwarded messages, sender of the original message',
  `forward_date` timestamp NULL DEFAULT NULL COMMENT 'For forwarded messages, date the original message was sent in Unix time',
  `reply_to_chat` char(20) DEFAULT NULL COMMENT 'Chat identifier.',
  `reply_to_message` bigint(20) unsigned DEFAULT NULL COMMENT 'Message is a reply to another message.',
  `text` text COMMENT 'For text messages, the actual UTF-8 text of the message max message length 4096 char utf8',
  `entities` text COMMENT 'For text messages, special entities like usernames, URLs, bot commands, etc. that appear in the text',
  `audio` text COMMENT 'Audio object. Message is an audio file, information about the file',
  `document` text COMMENT 'Document object. Message is a general file, information about the file',
  `photo` text COMMENT 'Array of PhotoSize objects. Message is a photo, available sizes of the photo',
  `sticker` text COMMENT 'Sticker object. Message is a sticker, information about the sticker',
  `video` text COMMENT 'Video object. Message is a video, information about the video',
  `voice` text COMMENT 'Voice Object. Message is a Voice, information about the Voice',
  `caption` text COMMENT 'For message with caption, the actual UTF-8 text of the caption',
  `contact` text COMMENT 'Contact object. Message is a shared contact, information about the contact',
  `location` text COMMENT 'Location object. Message is a shared location, information about the location',
  `venue` text COMMENT 'Venue object. Message is a Venue, information about the Venue',
  `new_chat_member` char(20) DEFAULT NULL COMMENT 'User id. A new member was added to the group, information about them (this member may be bot itself)',
  `left_chat_member` char(20) DEFAULT NULL COMMENT 'User id. A member was removed from the group, information about them (this member may be bot itself)',
  `new_chat_title` char(255) DEFAULT NULL COMMENT 'A group title was changed to this value',
  `new_chat_photo` text COMMENT 'Array of PhotoSize objects. A group photo was change to this value',
  `delete_chat_photo` tinyint(1) DEFAULT '0' COMMENT 'Informs that the group photo was deleted',
  `group_chat_created` tinyint(1) DEFAULT '0' COMMENT 'Informs that the group has been created',
  `supergroup_chat_created` tinyint(1) DEFAULT '0' COMMENT 'Informs that the supergroup has been created',
  `channel_chat_created` tinyint(1) DEFAULT '0' COMMENT 'Informs that the channel chat has been created',
  `migrate_from_chat_id` char(20) DEFAULT NULL COMMENT 'Migrate from chat identifier.',
  `migrate_to_chat_id` char(20) DEFAULT NULL COMMENT 'Migrate to chat identifier.',
  `pinned_message` text COMMENT 'Pinned message, Message object.',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `forward_from` (`forward_from`),
  KEY `reply_to_chat` (`reply_to_chat`),
  KEY `reply_to_message` (`reply_to_message`),
  KEY `new_chat_member` (`new_chat_member`),
  KEY `left_chat_member` (`left_chat_member`),
  KEY `migrate_from_chat_id` (`migrate_from_chat_id`),
  KEY `migrate_to_chat_id` (`migrate_to_chat_id`),
  KEY `reply_to_chat_2` (`reply_to_chat`,`reply_to_message`),
  KEY `message_ibfk_2` (`chat_id`),
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `message_ibfk_2` FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`),
  CONSTRAINT `message_ibfk_3` FOREIGN KEY (`forward_from`) REFERENCES `user` (`id`),
  CONSTRAINT `message_ibfk_4` FOREIGN KEY (`reply_to_chat`, `reply_to_message`) REFERENCES `message` (`chat_id`, `id`),
  CONSTRAINT `message_ibfk_5` FOREIGN KEY (`forward_from`) REFERENCES `user` (`id`),
  CONSTRAINT `message_ibfk_6` FOREIGN KEY (`new_chat_member`) REFERENCES `user` (`id`),
  CONSTRAINT `message_ibfk_7` FOREIGN KEY (`left_chat_member`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message`
--

LOCK TABLES `message` WRITE;
/*!40000 ALTER TABLE `message` DISABLE KEYS */;
/*!40000 ALTER TABLE `message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `texto` text NOT NULL,
  `resp1` varchar(255) DEFAULT NULL,
  `resp2` varchar(255) DEFAULT NULL,
  `resp3` varchar(255) DEFAULT NULL,
  `resp4` varchar(255) DEFAULT NULL,
  `respOK` varchar(1) DEFAULT NULL,
  `why` text,
  `whynot` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (1,'El siguiente trozo de código en Javascript:  \n  var miArray = new Array(4);\n   miArray[4] = 0;','Arroja un error por acceder a una posición del array no existente','Añade la posición 4 del array e inicializa a 0 esa y todas las posiciones anteriores','Añade la posición 4 del array e inicializa a 0 únicamente esa posición',NULL,'3',NULL,NULL),(2,'El siguiente trozo de código en Javascript:  \n \n   var miArray = new Array(4);\n    miArray[0] += 1;\n','Arroja un error de ejecución','Inicializa la posición 0 del array a 1','Inicializa la posición 0 del array al valor NaN (Not a Number)','Ninguna de las anteriores','3',NULL,NULL),(3,'La siguiente sentencia Javascript: \n\n   var in = 2;\n','Asigna el valor entero 2 a la variable in','Arroja un error de ejecución','Arroja un error de sintaxis','Ninguna de las anteriores','3',NULL,NULL),(4,'La siguiente sentencia Javascript:  \n\n     var 2_in = 2;\n','Es válida y asigna un 2 a la variable 2_in','Es incorrecta, dado que el nombre de variable 2_in contiene la palabra reservada \"in\"','Es incorrecta dado que el nombre de variable empieza por un número',NULL,'3',NULL,NULL),(5,'¿Cuál es el resultado en pantalla de ejecutar las siguientes instrucciones? \n \n<b>var lenguajes = [\"C++\", \"Java\", \"JavaScript\", \"Pascal\"];\nvar modernos = [\"Dart\", \"Go\", \"Ruby\", \"Clojure\"]; \nlenguajes.concat(modernos);\n</b>','[\"Dart\", \"Go\", \"Ruby\", \"Clojure\",\"C++\", \"Java\", \"JavaScript\", \"Pascal\"]','[\"C++\", \"Java\", \"JavaScript\", \"Pascal\", \"Dart\", \"Go\", \"Ruby\", \"Clojure\"]','[C++, Java, JavaScript, Pascal, Dart, Go, Ruby, Clojure]','\"C++\", \"Java\", \"JavaScript\", \"Pascal\", \"Dart\", \"Go\", \"Ruby\", \"Clojure\"','2',NULL,NULL),(6,'¿Cuál es el contenido de la variable \"trozo\" tras ejecutar las siguientes instrucciones? \n<b>var lenguajes = [\"C++\", \"Java\", \"JavaScript\", \"Pascal\"];\nvar trozo = lenguajes.slice(1,3); \n</b>','[\"Java\", \"JavaScript\"]','[\"Javascript\", \"Java\"]','[\"Java\", \"JavaScript\", \"Pascal\"]','[\"C++\", \"Java\", \"JavaScript\"]','1',NULL,NULL),(7,'¿Cuál es el contenido de la variable lenguajes tras ejecutar las siguientes instrucciones? \n<b>var lenguajes = [\"C++\", \"Java\", \"JavaScript\", \"Pascal\"];\nvar incognita = lenguajes.pop();\nlenguajes.push(\"Ada\");\nlenguajes.push(incognita);\n</b>','[\"C++\", \"Java\", \"JavaScript\", \"Ada\", \"Pascal\"]','[\"C++\", \"Java\", \"JavaScript\", \"Pascal\", \"Ada\"]','[\"Java\", \"JavaScript\", \"Pascal\", \"Ada\"]',NULL,'1',NULL,NULL),(8,'¿Cuál es el resultado en pantalla de ejecutar las siguientes instrucciones?\n<b>var lenguajes = [\"C++\", \"Java\", \"JavaScript\", \"Pascal\"]; \nlenguajes.join(\" y \");\n</b>','\"C++\", \"Java\", \"JavaScript\", \"Pascal\", \"y\"','\"y\", \"C++\", \"Java\", \"JavaScript\",\"Pascal\"','[\"C++ y Java y JavaScript y Pascal\"]','\"C++ y Java y JavaScript y Pascal\"','4',NULL,NULL),(9,'El objeto String de JavaScript, ¿dispone del método reverse() para invertir una cadena de texto?  Es decir, ¿podemos ejecutar este código sin recibir un error?\n\n<b>  var cadena = \"prueba\";\n   cadena.reverse(); \n</b>','Sí, se puede ejecutar sin recibir ningún error, pero no invertirá la cadena','Sí, se puede ejecutar e invertirá la cadena','Al ejecutarlo recibiremos un error, porque el objeto String no dispone de un método reverse.',NULL,'3',NULL,NULL),(10,'Si quisiéramos invertir el texto contenido en un string, podríamos hacer lo siguiente:\n\n<b>var cadena = \"prueba\";\ncadena.split(\"\").reverse().join(\"\");\n</b>\n\nEsa línea:','convierte la cadena en un string de caracteres (split(\"\")), invierte el string (reverse()), y vuelve a unir los caracteres para formar el string invertido (join(\"\"))','convierte la cadena en un array de caracteres (split(\"\")), invierte el array (reverse()), y vuelve a unir los caracteres para formar el string invertido (join(\"\"))','convierte la cadena en un array de caracteres (join(\"\")), invierte el array (reverse()), y vuelve a unir los caracteres para formar el string invertido (split(\"\"))',NULL,'2',NULL,NULL),(11,'Si hacemos lo siguiente:\n\n<b>String.prototype.reverse = function () {\n  return this.split(\"\").reverse().join(\"\");\n };\n</b>\n\n Estaremos añadiendo la función reverse() al objeto String. Si ejecutamos ahora estas líneas (las mismas que el primer ejercicio):\n \n<b>var cadena = \"prueba\";\n  cadena.reverse();\n</b>\n','Ahora sí se puede ejecutar sin recibir ningún error, pero seguirá sin invertir la cadena','Se puede ejecutar sin recibir ningún error y devolverá el texto de la cadena de forma invertida (pero la cadena no se modificará)','Se puede ejecutar sin recibir ningún error y devolverá el texto de la cadena de forma invertida (modificando además la variable cadena)','Al ejecutarlo recibiremos un error, porque el objeto String no dispone de un método reverse.','2',NULL,NULL),(12,'El siguiente método (conocido como algoritmo de Fisher-Yates):\n<b>\nArray.prototype.shuffle = function() {\n var i = this.length, j, temp;\n  if ( i == 0 ) return this;\n  while ( --i ) {\n     j = Math.floor( Math.random() * ( i + 1 ) );\n     temp = this[i];\n     this[i] = this[j];\n     this[j] = temp;\n  }\n  return this;\n}\n</b>\n','añade una función al prototipo del objeto Array, para sumar una unidad a todas las celdas','añade una función al prototipo del objeto Array, para invertir su contenido','añade una función al prototipo del objeto Array, para barajar su contenido',NULL,'3',NULL,NULL),(13,'En el ejemplo productos10.html de los vídeos de esta semana, se recorren los elementos del array tienda usando la construcción  for(..in..). En concreto:  \n<b>\n var tienda = []; \n  tienda.push(libro1, libro2, disco1); \n  for (producto in tienda) { \n     //...   console.log(producto); \n  //... \n} </b>\n\n Sin embargo, el uso de for(..in..) no está recomendado para recorrer un array cuando se han añadido funciones a su prototipo. Por ejemplo, si hemos añadido la función shuffle() al prototipo de Array (ver ejercicio anterior). ¿Por qué no se recomienda el uso de for(..in..) en ese caso?\n','Porque para recorrer los elementos de un array siempre hay que usar la construcción \nfor (var i = 0; i &lt; tienda.length; i++) { ... }\n','Porque for(..in..) mostraría no sólo los elementos del array (libro1, libro2, disco1 en el ejemplo), sino que también tomaría la función shuffle() como un elemento más del array.\n','Porque al añadir una función al prototipo de Array ya no es posible recorrer sus elementos con la construcción for(..in..)\n',NULL,'2',NULL,NULL),(14,'Hasta ahora, hemos accedido a los elementos DOM gracias a que todos ellos tenían identificadores asociados. Sin embargo, en muchas ocasiones el elemento DOM al que queremos acceder no tendrá directamente un identificador asociado, sino que será hijo (o nieto, bisnieto...) de un elemento con id. Por ejemplo, el texto enmarcado en rojo está dentro de una etiqueta &lt;p> sin identificador. El identificador más cercano en el árbol DOM es el de la etiqueta &lt;div id=”main”>.  \n\nPara acceder al elemento encuadrado en rojo (etiqueta &lt;p>), debemos recorrer los elementos hijo de &lt;div id=”main”> hasta llegar al que nos interesa.  \n\n¿Cuántos nodos hijo tiene el elemento &lt;div id=”main”>? Es decir, cuál es el resultado de ejecutar: \n\nvar padre = document.getElementById(\"main\");  padre.children.length ','4 hijos','5 hijos ','6 hijos ','7 hijos','3',NULL,NULL),(15,'Siguiendo con el ejercicio anterior, ¿cuál es el tercer hijo del elemento padre? Es decir, cuál es el resultado de ejecutar:  \n\nvar padre = document.getElementById(\"main\"); \npadre.children[2]  \n\n(recuerda que los índices comienzan en 0) ','&lt;aside>...&lt;/aside>','&lt;div class=”boxmenu”>...&lt;/div>','&lt;h2>Second Menu\' Lipsum Lorem&lt;/h2>','&lt;details>...&lt;/details>','2',NULL,NULL),(16,'Siguiendo con el ejercicio anterior, ¿cuál es el primer hijo del segundo hijo del elemento padre? Es decir, cuál es el resultado de ejecutar:\n\nvar padre = document.getElementById(\"main\");\n padre.children[1].children[0]\n \n','&lt;aside>...&lt;/aside>','&lt;div class=”boxmenu”>...&lt;/div>','&lt;h2>Second Menu\' Lipsum Lorem&lt;/h2>','&lt;a href=”#”>...&lt;/a>','4',NULL,NULL),(17,'¿Cómo cambiar entonces el texto enmarcado en rojo (en la página web de ejemplo), a través de JavaScript, para que ponga “Pimientos, patatas, tomate, berenjena” cuando carga la página?\n','window.onload = function(){ var padre = document.getElementById(\"main\"); padre.children[1].children[0].innerHTML = \"Pimientos, patatas, tomate, berenjena\"};','window.onload = function(){ var padre = document.getElementById(\"main\"); padre.children[0].children[1].innerHTML = \"Pimientos, patatas, tomate, berenjena\" };','window.onload = function(){ var padre = document.getElementById(\"main\"); padre.children[1].children[1].innerHTML = \"Pimientos, patatas, tomate, berenjena\"};',NULL,'3',NULL,NULL),(18,'Siguiendo con el mismo ejemplo, si defino los siguientes dos gestores de eventos tal y como especifica el W3C DOM:\n \nvar padre = document.getElementById(\"main\");\npadre.addEventListener(\"click\", function(){console.log(\'primer listener\')});\npadre.addEventListener(\"click\", function(){console.log(\'segundo listener\')});\n\nEntonces, al pulsar sobre la capa “main”, ocurrirá lo siguiente:\n','se mostrará en consola el mensaje “primer listener” (es decir, sólo el primer gestor, el segundo no se trata)','se mostrará en consola el mensaje “segundo listener” (es decir, sólo el segundo gestor, el primero no se trata)','se mostrarán en consola ambos mensajes (es posible definir tantos listener como se desee sobre el mismo elemento y evento)','no se mostrará nada, porque saltará un error debido a que no se pueden definir dos listeners sobre el mismo evento del mismo elemento.','3',NULL,NULL),(19,'Siguiendo con el mismo ejemplo, ¿qué ocurrirá si defino los siguientes gestores de eventos?\n\nvar padre = document.getElementById(\"main\");\n\npadre.addEventListener(\"click\", function(){console.log(\'primer listener\')});\n\npadre.addEventListener(\"click\", function(){console.log(\'segundo listener\')});\n\npadre.addEventListener(\"click\", function(){console.log(\'primer listener\')});\n\npadre.addEventListener(\"click\", function(){console.log(\'segundo listener\')});\n\nAl pulsar sobre la capa “main”, ocurrirá lo siguiente:','se mostrará en consola el mensaje “primer listener”, “segundo listener”, “primer listener”, “segundo listener”',' se mostrará en consola el mensaje “primer listener”, “segundo listener” (dado que se repiten las definiciones de gestores, sólo se trataran aquellos que sean diferentes)','no se mostrará nada, porque saltará un error debido a que no se pueden definir dos listeners sobre el mismo evento del mismo elemento.','no se mostrará nada, porque saltará un error debido a que no se pueden definir dos listeners exactamente iguales sobre el mismo elemento y evento.','1',NULL,NULL),(20,'Una de las ventajas de definir gestores de eventos tal y como especifica el W3C DOM es que pueden eliminarse con el método removeListener. Por ejemplo, si defino el siguiente gestor de eventos:\n function gestorClick() {\n  alert(\'hola\');\n}\nvar padre = document.getElementById(\"main\");\npadre.addEventListener(\"click\", gestorClick);\n\n¿Cómo eliminar el gestor asociado al elemento padre?','padre.removeEventListener(\'click\', gestorClick);',' padre.removeEventListener(\'click\');','padre.removeEventListener(gestorClick);','ninguna de las opciones anteriores borra ambos gestores','1',NULL,NULL),(21,'Asumiendo que ctx es una variable que lleva el contexto de un elemento canvas,\n¿qué hacen las siguientes dos líneas?\n<i>\nctx.fillStyle = \"black\"\nctx.fillRect(15,15,4,4);\n</i>','Muestran un rectángulo de 4x4 en la posición 15,15 (con fondo negro)',' Muestran un rectángulo de 15x15 en la posición 4,4 (con fondo negro)',' Muestran un rectángulo de 4x4 en la posición 15,15 (con perfil onegro)','Muestran un rectángulo de 15x15 en la posición 4,4 (con perfil negro)','1',NULL,NULL),(22,'Asumiendo que ctx es una variable que lleva el contexto de un elemento canvas.\nEl siguiente código:\n<i>\nctx.fillStyle = \"red\";\nctx.fillStyle = \"black\";\nctx.fillRect(15, 15, 4, 4);\nctx.fillRect(25, 25, 4, 4);\n</i>','Mostrará dos rectángulos negros',' Mostrará un rectángulo rojo y uno negro',' Mostrará dos rectángulos rojos',' Mostrará un único rectángulo negro ','1',NULL,NULL),(23,'Asumiendo que ctx es una variable que lleva el contexto de un elemento canvas.\nEl siguiente código:\n<i>\nctx.fillStyle = \"red\";\nctx.save();\nctx.fillStyle = \"black\";\nctx.fillRect(15, 15, 4, 4);\nctx.restore();\nctx.fillRect(25, 25, 4, 4);\n</i>',' Mostrará dos rectángulos negros','Mostrará un rectángulo rojo y uno negro','Mostrará dos rectángulos rojos','Mostrará un único rectángulo negro','2',NULL,NULL),(24,'Asumiendo que ctx es una variable que lleva el contexto de un elemento canvas.\nEl siguiente código:\n<i>\nctx.fillStyle = \"red\";\nctx.translate(150, 150);\nctx.fillRect(15, 15, 4, 4);\n</i>','Pinta un cuadrado rojo en 150,150','Pinta un cuadrado rojo en 15,15','Pinta un cuadrado rojo en 165,165','Pinta un cuadrado rojo en 4,4','3',NULL,NULL),(25,'Asumiendo que ctx es una variable que lleva el contexto de un elemento canvas.\nEl siguiente código:\n<i>\nctx.fillStyle = \"red\";\nctx.save();\nctx.translate(150, 150);\nctx.fillRect(15, 15, 4, 4);\nctx.restore();\nctx.fillRect(15, 15, 4, 4);\n</i>\n','Pinta dos cuadrados en la misma posición','Pinta dos cuadrados: uno en 15,15 y el otro en 150,150','Pinta dos cuadrados: uno en 4,4 y el otro en 15,15','Pinta dos cuadrados: uno en 15,15 y el otro en 165,165','4',NULL,NULL),(26,'¿Qué variable podemos consultar para saber si el navegador del usuario tiene soporte para usar el API de geolocalización?','navigator.geolocation','window.geolocation','document.geolocation','window.currentPosition','1',NULL,NULL),(27,'Supongamos que queremos responder al método getCurrentPosition de navigator.geolocation con la función mostrarLocalizacion. Entonces, una invocación correcta sería la siguiente:','navigator.geolocation.getCurrentPosition( mostrarLocalizacion() );','navigator.geolocation.getCurrentPosition.mostrarLocalizacion;','navigator.geolocation.getCurrentPosition.mostrarLocalizacion();','navigator.geolocation.getCurrentPosition( mostrarLocalizacion );','4',NULL,NULL),(28,'Supongamos que tenemos definida la siguiente función de callback para getCurrentPosition :\n\n<i>navigator.geolocation.getCurrentPosition( mostrarLocalizacion );</i>\n\nEntonces, la firma del método mostrarLocalizacion debe ser la siguiente:','function mostrarLocalizacion(posicion)','function mostrarLocalizacion()','var mostrarLocalizacion = function(posicion);',' a y c son correctas','4',NULL,NULL),(29,'Para pintar un mapa de Google Maps en pantalla, usando las coordenadas que hayamos obtenido mediante el API de Geolocalización, nos bastará con hacer uso de al menos las siguientes funciones:','google.maps.LatLng y google.maps.Map','google.maps.Position y google.maps.Map','google.maps.Position y google.maps.DrawMap','google.maps.LatLng y google.maps.DrawMap','1',NULL,NULL),(30,'Cuando pintamos un mapa de Google Maps en pantalla, veremos automáticamente un Marker mostrándonos la posición actual.','Cierto, por defecto se muestra un marker con la posición actual','Falso, los marker hay que ponerlos explícitamente','Cierto, pero sólo en Google Chrome (en Firefox, no)','Cierto, pero sólo en Firefox (en Google Chrome, no)','2',NULL,NULL),(31,'Supongamos que tenemos el siguiente objeto JSON\n\n<i>\nvar data = {\n  \"ventana\": {\n    \"título\": \"Sample Widget\",\n    \"anchura\": 500,\n    \"altura\": 500\n  },\n  \"imagen\": { \n    \"src\": \"images/logo.png\",\n    \"coords\": [250, 150, 350, 400],\n    \"alineación\": \"center\"\n  },\n  \"mensajes\": [\n    {\"texto\": \"Save\", \"offset\": [10, 30]},\n    {\"texto\": \"Help\", \"offset\": [ 0, 50]},\n    {\"texto\": \"Quit\", \"offset\": [30, 10]}\n  ],\n  \"debug\": \"true\"\n}\n</i>\n\n¿Cómo accederíamos al título de la ventana? (la expresión tiene que devolver “Sample Widget”)\n','data.ventana.título','data.título','ventana.data.título','data.ventana.título.value','1',NULL,NULL),(32,'¿Cómo accederíamos a la tercera coordenada de la imagen? (la expresión tiene que devolver 350)','data.imagen.coords[3]','imagen.coords[3]','imagen.coords[2]','data.imagen.coords[2]','4',NULL,NULL),(33,'¿Cómo calcular cuántos mensajes hay? (la expresión tiene que devolver 3)','data.mensajes.size','mensajes.length()','data.mensajes.length','data.mensajes.length()','3',NULL,NULL),(34,'¿Cuál es el 2º offset del último mensaje? (la expresión tiene que devolver 10. Supongamos que no sabemos cuántos mensajes hay - es decir, no usar directamente el índice [2] del array de mensajes )','data.mensajes[data.mensajes.length-1].offset[1]','data.menesajes[data.mensajes.length].offset[1]','data.mensajes.length.offset[1]','data.mensajes[length-1].offset[1]','1',NULL,NULL),(35,'¿Cuáles son los nombres de los atributos de primer nivel del objeto JSON? (la expresión, probablemente de varias líneas, me tiene que devolver “ventana,imagen,mensajes,debug\"como resultado)','var res = []; for (var i in data) res.push(i); res.join(\",\");','var res = []; for (var i in data) { res.join(\",\"); } res.push(i);','var res = []; for (var i in data) res.join(\",\");','var res = []; for (var i in data) res.push(i);','1',NULL,NULL),(36,'El siguiente trozo de código:\n\n<i>\n	$.ajax({url:direccion , success: function(result){\n  			mostrarLibros(result);\n  		},\n  		error: function(request,error){\n  			alert(\"Error: \"+error);\n  		}\n  		});\n</i>','Es una función JavaScript que no necesita librerías externas para funcionar',' Es una función JavaScript que necesita jQuery para funcionar, pero le faltaría la instrucción $.ajax().send() para ejecutar la petición XMLHttpRequest','Es una función JavaScript que necesita jQuery para funcionar. Realizará correctamente la llamada XMLHttpRequest a la dirección indicada','Es una función JavaScript que no necesita librerías externas para funcionar,  pero le faltaría la instrucción $.ajax().send()','3',NULL,NULL),(37,'La propiedad playbackRate de un elemento &lt;video> permite:','Darle una puntuación al vídeo, para que otros usuarios sepan si el vídeo nos gustó o no','Conocer la velocidad de reproducción del vídeo (es un atributo de sólo lectura)','Conocer o cambiar la velocidad de reproducción del vídeo (es un atributo de lectura/escritura)',NULL,'3',NULL,NULL),(38,'La propiedad currentTime permite desplazarnos en el vídeo, hacia delante o hacia atrás, de forma programática. Al cambiar el valor currentTime se elevan los siguientes eventos:','seeking','seeking y seeked, en ese orden','seeked y seeking, en ese orden',NULL,'2',NULL,NULL),(39,'¿Cuál es el último evento que se lanza al mover el control señalado en rojo de un elemento vídeo?','seeking','seeked','scrubbed',NULL,'2',NULL,NULL),(40,'El evento progress del elemento &lt;video> sólo se emite cuando el vídeo está en modo play:','Cierto. sólo cuado el vídeo se está visualizando','Falso, también cuando está en modo pausa (porque el vídeo se está cacheando)','Falso, también cuando está en modo pausa (aunque el vídeo ya se haya cacheado)',NULL,'2',NULL,NULL),(41,'La propiedad playbackRate toma valores entre 0 y 1.','Cierto','Falso, puede tomar valores mayores que 0 y superiores a 1 ','Falso, puede tomar valores entre 1 e infinito',NULL,'2',NULL,NULL),(42,'¿Qué atributo de elemento de un form se usa para conseguir situar el cursor en ese campo en concreto?','auto','autofocus','placeholder','autoplace','2',NULL,NULL),(43,'Si pulsamos dos veces en un campo list con un Datalist asignado:','se despliegan todas las opciones posibles','el primer click abre el campo, el segundo click lo cerraría','el primer click despliega el campo con todas las opciones posibles',NULL,'1',NULL,NULL),(44,'Un campo Datalist en HTML5...','es un campo &lt;select&gt; con un &lt;datalist&gt; interno','es un campo &lt;input type=\"text\"&gt; con un &lt;datalist&gt; interno','es un campo &lt;input type=\"text\"&gt; con una referencia a un &lt;datalist&gt; en concreto',NULL,'3',NULL,NULL),(45,'Según la especificación, el atributo autocomplete de los campos de un formulario:\n(el atributo autocomplete permite sugerir al usuario el contenido de un campo de texto basándose en lo que éste usuario haya tecleado en otras ocasiones):','está desactivado (off)','la especificación no define el estado','está activado (on)',NULL,'3',NULL,NULL),(46,'El campo &lt;input type=\"file\"&gt; permite aceptar únicamente sólo ciertos tipos de ficheros. Por ejemplo, al pulsar sobre él, se quiere que el usuario sólo pueda seleccionar imágenes. Para ello, en el código HTML5 deberemos teclear lo siguiente:','&lt;input type=\"file\" allowed=\"image/*\"&gt;','&lt;input type=\"file\" accept=\"image\"&gt;','&lt;input type=\"file\" accept=\"image/*\"&gt;','&lt;input type=\"file\" allowed=\"image\"&gt;','3',NULL,NULL),(47,'Si llamamos al método setItem() con una clave que ya exista en el repositorio, ¿qué ocurrirá?','Se sobreescribirá el valor anterior que tuviera esa clave','Se elevará una excepción','Se mantendrá el valor anterior que tuviera esa clave',NULL,'1',NULL,NULL),(48,'Llamar a getItem() con una clave que no exista:','devolverá null ','elevará una excepción','devolverá la cadena vacía',NULL,'1',NULL,NULL),(49,'Llamar a removeItem() con una clave que no exista,','no hará nada ','guardará esa clave con el valor null','arrojará una excepción',NULL,'1',NULL,NULL),(50,'Si llamamamos al método key() con un índice que no esté entre 0-(length-1):','se elevará un error','se generará una nueva entrada con esa clave y valor nulo','la función devolverá null ',NULL,'3',NULL,NULL),(51,'¿Es posible acceder a los valores de localStorage insertados por un dominio (p. ej. abc .com) desde el código JavaScript de otro dominio (p. ej. def .com)?','sí, es posible en cualquier caso','no, no es posible en ningún caso','es posible siempre que los dominios usen el protocolo https',NULL,'2',NULL,NULL),(52,'Los datos guardados en localStorage pueden ser de cualquier tipo incluyendo strings, booleans, integers, o floats.','No, no se pueden guardar booleanos','Sí, pero internamente se guardan como Strings (al extraerlos hay que hacer un casting) ','Sí, y al extraerlos no hay que hacer ningún tipo de casting (JavaScript hará un autocast)','No, sólo se pueden guardar variables de tipo String','2',NULL,NULL),(53,' Supongamos que tenemos el siguiente trozo de código fuente:\n<i>\ny = 1;\n\n  function hello(){\n    \"use strict\";\n     x = 2;\n  }\n</i>\nEntonces:\n','Hay un error dado que \"use strict\" no se puede usar dentro del ámbito de una función','Hay un error porque al haber utilizado un \"use strict\" no podemos asignar 1 a la variable y','Hay un error porque al haber utilizado un \"use strict\" no podremos asignar 2 a la variable x','Hay dos errores, porque al haber utilizado un \"use strict\" no podemos asignar 1 a \'y\' ni 2 a \'x\'','3','El modo \"Strict\" permite generar código JavaScript más robusto, evitando errores que el programador podría cometer por descuido.\nPor ejemplo, el modo strict hace que todas las variables deban ser declaradas antes de ser usadas. Esto evita que por descuido por un error al teclear el nombre de la variable, por ejemplo) el programador asigne un valor a una variable que no existe, creando una variable global como efecto lateral.\n','\"use strict\" se puede usar a nivel global (al comienzo del script) o dentro del ámbito de una función (al comienzo de la función).'),(54,'Los elementos que se quieren guardar para ser accedidos offline por un ServiceWorker se almacenarán\nen:','Una cookie','LocalStorage','CacheStorage',NULL,'3','cachestorage está especialmente preparado para ser usado por los serviceWorkers como almacén de elementos que serán usados al trabajar sin conexión. La Mozilla Developer Network la define como tecnología experimental. Aunque funciona correctamente en Firefox y Chrome, el soporte no está implementado en IE y Safari.','un ServiceWorker preparado para trabajar offline puede requerir almacenar grandes cantidades de datos (texto, gráficos, elementos multimedia). Las cookies se quedan extremadamente pequeñas y localStorage está pensado para almacenar objetos de tipo string (u otros objetos JSON serializados), no binarios.\n'),(55,'Podemos añadir elementos a una cache de CacheStorage, una vez abierta:\n(Pista: https://developer.mozilla.org/en-US/docs/Web/API/CacheStorage )','sólo en el gestor del evento install de un ServiceWorker','sólo en el gestor del evento fetch de un ServiceWorker','tanto en gestor de install como en el gestor de fetch',NULL,'3',' en el gestor de install el SW suele cachear típicamente los recursos que vaya a necesitar al estar offline.\nEn el gestor de fetch podría ir a buscar el recurso a Internet y en caso de no disponer de una copia en la caché, añadirlo también a dicha caché.','no hay ninguna norma que limite el poder añadir elementos a la caché en ningún momento dado.'),(56,' El objeto cache de tipo CacheStorage tiene los siguientes métodos:','delete, keys, match, matchAll, add, addAll, put','remove, keys, match, add, addAll, put',' remove, keys, match, matchAll, add, addAll, put','delete, keys, match, add, addAll, put','1','Puede consultarse la lista de métodos del CacheStorage API aquí:\nhttps://developer.mozilla.org/en-US/docs/Web/API/Cache#Methods\n','En la lista de métodos del CacheStorage API:\nhttps://developer.mozilla.org/en-US/docs/Web/API/Cache#Methods\nno figura el método remove (es delete). A la opción d. le falta el matchAll '),(57,' Un Service Worker puede responder a un evento fetch entregando:',' una respuesta obtenida desde la cache o directamente de su localización en Internet',' una respuesta obtenida desde la cache, directamente de su localización en Internet o generada dinámicamente',' una respuesta obtenida desde la cache o generada dinámicamente',NULL,'2',' un SW puede generar una respuesta (Response) al vuelo, o bien obtenerla de Internet (si detecta conexión) o de la caché (si no hay conexión o si aún habiéndola, se prefiere responder desde la caché)',' a las respuestas a y c les falta una opción (las 3 opciones están en b)'),(58,'Al actualizar el código de un Service Worker (SW), es recomendable:\n(Pista:  https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers#Updating your service worker )','que el nuevo SW reutilice la misma versión de la cache que el viejo','que el nuevo SW utilice una nueva versión de la cache',NULL,NULL,'2','es conveniente crear una nueva versión del SW que use, a su vez, una nueva versión de la caché. Así, las peticiones que estén llegando al SW viejo se terminarán de servir correctamente antes de que el SW nuevo tome el control con una nueva versión de la caché.','el nuevo SW podría necesitar almacenar nuevos recursos de la caché (y eliminar los viejos). Esto se puede hacer eficientemente actualizando la versión de la caché.'),(59,'Para poder ver la lista de todos los objetos cache que el navegador tenga cargados en la CacheStorage, \npodemos hacer lo siguiente:','caches.keys().then(function(keyList) { console.log(keyList) } )','console.log(caches.keys())','CacheStorage.keys().then(function(keyList) { console.log(keyList) } )','console.log(CacheStorege.keys())','1','caches.keys() obtiene las claves almacenadas en la Cache Storage del dominio del SW. Una vez obtenidas (then), se muestran por consola.','las operaciones con el objeto caches deben ser resueltas por medio de Promises (promesas), es decir, deben seguir la estructura caches.comando.then( ) . Por otro lado, el objeto global CacheStorage no existe.');
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz`
--

DROP TABLE IF EXISTS `quiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quiz` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `data` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz`
--

LOCK TABLES `quiz` WRITE;
/*!40000 ALTER TABLE `quiz` DISABLE KEYS */;
INSERT INTO `quiz` VALUES (1,'Test JavaScript básico','2016-01-25 00:00:00'),(2,'Poo en JS','2016-02-10 23:16:00'),(3,'Gestores de eventos','2016-02-17 23:16:00'),(4,'Pintando en pantalla. Canvas y SVG','2016-02-26 13:00:00'),(5,'API de Geoposicionamiento','2016-03-07 10:00:00'),(6,'Comunicación de datos. JSON y Ajax','2016-03-23 10:00:00'),(7,'API Video y Audio','2016-04-20 10:00:00'),(8,'Formularios','2016-05-01 10:00:00'),(9,'WebStorage','2016-05-01 10:00:00'),(10,'Offline Applications (Service Workers)','2016-05-10 12:00:00');
/*!40000 ALTER TABLE `quiz` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quizquestions`
--

DROP TABLE IF EXISTS `quizquestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quizquestions` (
  `quizId` int(11) NOT NULL,
  `questionId` int(11) NOT NULL,
  `questionPos` int(11) NOT NULL,
  PRIMARY KEY (`quizId`,`questionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quizquestions`
--

LOCK TABLES `quizquestions` WRITE;
/*!40000 ALTER TABLE `quizquestions` DISABLE KEYS */;
INSERT INTO `quizquestions` VALUES (1,1,1),(1,2,2),(1,3,3),(1,4,4),(1,5,5),(1,6,6),(1,7,7),(1,8,8),(2,9,1),(2,10,2),(2,11,3),(2,12,4),(2,13,5),(3,14,1),(3,15,2),(3,16,3),(3,17,4),(3,18,5),(3,19,6),(3,20,7),(4,21,1),(4,22,2),(4,23,3),(4,24,4),(4,25,5),(5,26,1),(5,27,2),(5,28,3),(5,29,4),(5,30,5),(6,31,1),(6,32,2),(6,33,3),(6,34,4),(6,35,5),(6,36,6),(7,37,1),(7,38,2),(7,39,3),(7,40,4),(7,41,5),(8,42,1),(8,43,2),(8,44,3),(8,45,4),(8,46,5),(9,47,1),(9,48,2),(9,49,3),(9,50,4),(9,51,5),(9,52,6),(10,53,1),(10,54,2),(10,55,3),(10,56,4),(10,57,5),(10,58,6),(10,59,7);
/*!40000 ALTER TABLE `quizquestions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telegram_update`
--

DROP TABLE IF EXISTS `telegram_update`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `telegram_update` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'The update''s unique identifier.',
  `chat_id` char(20) DEFAULT NULL COMMENT 'Chat identifier.',
  `message_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Unique message identifier',
  `inline_query_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The inline query unique identifier.',
  `chosen_inline_query_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The chosen query unique identifier.',
  `callback_query_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The callback query unique identifier.',
  PRIMARY KEY (`id`),
  KEY `message_id` (`chat_id`,`message_id`),
  KEY `inline_query_id` (`inline_query_id`),
  KEY `chosen_inline_query_id` (`chosen_inline_query_id`),
  KEY `callback_query_id` (`callback_query_id`),
  CONSTRAINT `telegram_update_ibfk_1` FOREIGN KEY (`chat_id`, `message_id`) REFERENCES `message` (`chat_id`, `id`),
  CONSTRAINT `telegram_update_ibfk_2` FOREIGN KEY (`inline_query_id`) REFERENCES `inline_query` (`id`),
  CONSTRAINT `telegram_update_ibfk_3` FOREIGN KEY (`chosen_inline_query_id`) REFERENCES `chosen_inline_query` (`id`),
  CONSTRAINT `telegram_update_ibfk_4` FOREIGN KEY (`callback_query_id`) REFERENCES `callback_query` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telegram_update`
--

LOCK TABLES `telegram_update` WRITE;
/*!40000 ALTER TABLE `telegram_update` DISABLE KEYS */;
/*!40000 ALTER TABLE `telegram_update` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` char(20) NOT NULL DEFAULT '0' COMMENT 'Unique user identifier',
  `first_name` char(255) NOT NULL DEFAULT '' COMMENT 'User first name',
  `last_name` char(255) DEFAULT NULL COMMENT 'User last name',
  `username` char(255) DEFAULT NULL COMMENT 'User username',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date update',
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_chat`
--

DROP TABLE IF EXISTS `user_chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_chat` (
  `user_id` char(20) NOT NULL DEFAULT '0' COMMENT 'Unique user identifier',
  `chat_id` char(20) NOT NULL DEFAULT '0' COMMENT 'Unique user or chat identifier',
  `currentQuestion` int(6) DEFAULT '1',
  `currentQuiz` int(6) DEFAULT '1',
  `rightAnswers` int(6) DEFAULT '0',
  `wrongAnswers` int(6) DEFAULT '0',
  `channel_id` char(45) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`chat_id`),
  KEY `chat_id` (`chat_id`),
  CONSTRAINT `user_chat_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_chat_ibfk_2` FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_chat`
--

LOCK TABLES `user_chat` WRITE;
/*!40000 ALTER TABLE `user_chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_chat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voice`
--

DROP TABLE IF EXISTS `voice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voice` (
  `voice_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` char(20) NOT NULL DEFAULT '0',
  `question_id` int(11) NOT NULL,
  `voice` varchar(120) DEFAULT NULL,
  `sent` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`voice_id`),
  KEY `voice_ibfk_1_idx` (`question_id`),
  KEY `voice_ibfk_2` (`user_id`),
  CONSTRAINT `voice_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `voice_question` (`question_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `voice_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voice`
--

LOCK TABLES `voice` WRITE;
/*!40000 ALTER TABLE `voice` DISABLE KEYS */;
/*!40000 ALTER TABLE `voice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voice_question`
--

DROP TABLE IF EXISTS `voice_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voice_question` (
  `question_id` int(11) NOT NULL AUTO_INCREMENT,
  `texto` text CHARACTER SET latin1 NOT NULL,
  `deadline` datetime DEFAULT NULL,
  PRIMARY KEY (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voice_question`
--

LOCK TABLES `voice_question` WRITE;
/*!40000 ALTER TABLE `voice_question` DISABLE KEYS */;
/*!40000 ALTER TABLE `voice_question` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-02 16:54:40
