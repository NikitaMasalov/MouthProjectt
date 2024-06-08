-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: mydb
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cart_user` (`user_id`),
  KEY `fk_cart_product` (`product_id`),
  CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (29,3,1,1),(30,3,8,1),(31,3,6,1);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Пицца'),(2,'Напиток'),(3,'Бургер');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_has_product`
--

DROP TABLE IF EXISTS `category_has_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_has_product` (
  `category_id` int NOT NULL,
  `product_id` int NOT NULL,
  PRIMARY KEY (`category_id`,`product_id`),
  KEY `fk_Category_has_product_product1_idx` (`product_id`),
  KEY `fk_Category_has_product_Category1_idx` (`category_id`),
  CONSTRAINT `fk_Category_has_product_Category1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  CONSTRAINT `fk_Category_has_product_product1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_has_product`
--

LOCK TABLES `category_has_product` WRITE;
/*!40000 ALTER TABLE `category_has_product` DISABLE KEYS */;
INSERT INTO `category_has_product` VALUES (1,1),(2,3),(3,5),(2,6),(1,7),(1,8);
/*!40000 ALTER TABLE `category_has_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deliveryman`
--

DROP TABLE IF EXISTS `deliveryman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deliveryman` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `photo` blob,
  `number` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL,
  `orders_mouth` int DEFAULT NULL,
  `salary_mouth` decimal(10,2) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deliveryman`
--

LOCK TABLES `deliveryman` WRITE;
/*!40000 ALTER TABLE `deliveryman` DISABLE KEYS */;
INSERT INTO `deliveryman` VALUES (1,'Сергей','Анатолий',NULL,'9023414','ул Зимная д67/6',NULL,NULL,'$5$rounds=535000$NHnSHjNuQOSQbT/0$7pEGjQrRL79yGdgXZw5OSEFQmObdUvfxvHHXtR/oJBD'),(2,'Ник','Егоровия',NULL,'9032452','ул Домашняя д 89/5',NULL,NULL,'$5$rounds=535000$NHnSHjNuQOSQbT/0$7pEGjQrRL79yGdgXZw5OSEFQmObdUvfxvHHXtR/oJBD');
/*!40000 ALTER TABLE `deliveryman` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `price` decimal(10,2) NOT NULL,
  `status` enum('accepted','rejected','prepare','transferred for delivery','in delivery','delivered') NOT NULL,
  `address` varchar(255) NOT NULL,
  `payment` enum('Online',' Cash') NOT NULL,
  `order_time` datetime NOT NULL,
  `delivery_time` datetime DEFAULT NULL,
  `user_id` int NOT NULL,
  `deliveryman_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_order_user1_idx` (`user_id`),
  KEY `fk_order_deliveryman1_idx` (`deliveryman_id`),
  CONSTRAINT `fk_order_deliveryman1` FOREIGN KEY (`deliveryman_id`) REFERENCES `deliveryman` (`id`),
  CONSTRAINT `fk_order_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,4500.00,'in delivery','Ул Липопова д 90/7','Online','2024-06-08 02:57:30',NULL,1,2),(2,6000.00,'accepted','Ул Земная д 82/8','Online','2024-06-08 03:00:29',NULL,3,1),(3,3000.00,'in delivery','1','Online','2024-06-08 03:10:14',NULL,3,1),(4,9000.00,'in delivery','1','Online','2024-06-08 03:58:57',NULL,3,2),(5,1529.97,'accepted','1','Online','2024-06-08 06:38:20',NULL,3,NULL),(6,29.97,'accepted','1','Online','2024-06-08 10:54:51',NULL,3,NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_has_product`
--

DROP TABLE IF EXISTS `orders_has_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_has_product` (
  `orders_id` int NOT NULL,
  `product_id` int NOT NULL,
  `Count` int NOT NULL,
  PRIMARY KEY (`orders_id`,`product_id`),
  KEY `fk_order_has_product_product1_idx` (`product_id`),
  KEY `fk_order_has_product_order1_idx` (`orders_id`),
  CONSTRAINT `fk_order_has_product_order1` FOREIGN KEY (`orders_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_order_has_product_product1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_has_product`
--

LOCK TABLES `orders_has_product` WRITE;
/*!40000 ALTER TABLE `orders_has_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders_has_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text NOT NULL,
  `amount` int NOT NULL,
  `weight` float NOT NULL,
  `restaurant_id` int NOT NULL,
  `photo` blob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_product_restaurant1_idx` (`restaurant_id`),
  CONSTRAINT `fk_product_restaurant1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Пеперони',1500.00,'Лучшая пицца на свете а еще и дешевая',123,150,1,_binary '����\0JFIF\0\0\0\0\0\0��\0�\0\n\Z\Z\Z\Z\Z\Z\Z\Z\Z\Z\Z+%\Z($6$(,.222!7<71;+12.1(#)11319311;143131113.3111211111111111121111111111111��\0\0�\0�\"\0��\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0��\0B\0\0\0\0!1AQ\"aq��2��B��#Rbr������3�$D�CT���\0\Z\0\0\0\0\0\0\0\0\0\0\0\0��\0/\0\0\0\0\0\0\0!1A\"2Qa���q���3B#R��\0\0\0?\0��ÇR�����p�ABl?�O�����೬�̺�\n�(�DZk��$�$5!j��,������G�h��\Z�mV��eI�	�+h�kP��;U�2Q-�vE!�j�E����%D�+B�����M\\G+Z��ӈ��kj�tJRc�� �K	���Z�戊dr��-��-֨�+�Ӹ�\\�ʜ	& A��M`5�M#����ֻ5�\n0\"���+(Ĝ\n\"Wh�M8E\\V�#�d�|���i��+�`}:��Y��a��_���pG�>�u�xQ�������EF��1���2#H����\']y�F�0elu:5���N�RQ�E(�K(!k���DC@���jح=-�\' ��B�.=M�1]��V�Ʃ�iRk(�S&8EhoGs@a\\-l�van\n�d�]�\"�\\�ҍ�QK�r�3�ɩ�<0���D�K2*XKi%s��T[V���G�\0\rHd5*ͼ�^��qR,L�+�W-��R��Cn4�����CqZR�y���z��t�r:\Z��*JS�P�v�V��\"+���R�G�\"\\͑���11���{U���#+1���u4ׂpL���7�>LG�V&�л\r���V|��|S�Uɬ��+8��D�@;ռ�?-�Nu�T ub{�U�j�\r���*\r�&fyiֻ<!�.�W(���x���jRk�l���~g��B���R��J4\\t^�L��?c>k���e�\n�_��Ǻff\0��9\n�u\'S�O�Wh,9�F-�2����b��3��H\ZC_z��R	A<�ށ�q�b�6X�� ��h�/·vG�h�� �	�:A��5%M������\"@(k]�D�\0΅wm�[4�0����m�=-F����\rt�Ks�JW%jAZ�5�R9Z�,��k��G��XԌ-�Ұ!�R��jU� Ϣ����-�$M�� =��R?���&��D���z7ƛ�M-������u�э+s �ۙ����d�7:T{����=��&��Qfi�t���G:�N��m^��.�Kn<}��iHF���Fq��y���V:�zc�0&���c��O�W�b_bA��+�l�0�}t�*��xe���if�[�����A�\'mKh&iw�mͲ>nB4��>4����,���G��S1�+�nAo_�c[�M��2������g:�ן/O�w�k��;��c�\Z��%o�q��>����[���UsyH��z���J���b�k��PhTk����x\\.&M�bt\ZwZG���`W��ڝH�g����w�5�E��/��>�ԩ����ɑ5�+��y;�p���-C���A�ؘ�a���RT�<�y�ל��X����h����޴����0@X���ڍJ���h?�3r��FS*c���kC�\r\\x���i/Z	1\':g99�\rA��Y�^�3&`@���?Z\Z��\0��l�QTo�ocDK,{\Z�q,M�=��.eA\'Rz��V�v������\'Q\\��qb������0Emj��-�D��oɉ ,/N��7\r�42�\0e��$�O[�1̪hʈ\"�0�Xg���m������Mh�xzļ/��֐����\\[\\������F�f��V���	��]�@3Ĉ�k��+\0m��_Mp�<�+�����~����fS!a�(`&}6���C��&yN���ƣ��5]��a�TE����667U�M�_��M��Lh�=#��n�=�2�˜t�c4��K�~(6�	�1\"~da�/?\n��R�,�XNu�i��S��Am��|�|�H9�d���_���㾥`Oz2�N��>4>����t���k���)�}*�>�5�W�7�SY[�r4�Vf&绌*����,����m�t�4K�LP��P��=oQ>I��.����ӄq˖���Ӻ�D��W�?������i�0�O��g��o�%ƍU�i|�j��x��&A\0���|;���s\0u����gҽZ��X{�ue�rނ]\"*-�Lmj���\0�V܂A��$�\'Z��ϜR{ؖ�d]*{��#P9��:�o�6�Y�=��.\\\Z���,�H�-�X�$�Ҹ>��*���0g�Wv��4\Z�tuūr��P�����\\�����@�1�N�ro�J����\"�&E�X�������X	1\"	�N��\\ݥ`J�-zAUD��b&�r<�g\n��nڡ\0���U;c�>ͅ �$	$�`����Ӑ�%�����iLp�m.�C\n�΄y��*WyǑ�Ġb.3�v4\0�#��jիe�-��O!���5��PK�2fnD������ka�f�K~\0��y�}��C��\0\Z���.طq���.D.�D��u�<w�l�K���c}5�\'z���/��\0\"y�\'�N����a��wXG�\'c*\r���I�L�}��/_9�<��\0駀��(�����:�����ظ:����5:S�=��|9����m\r+@t=e�U@+�)��tL�@��;ìʯ\\M�R�\0:fhSU�|\n_�Ǡԯ���=��-�UR��@9g޳-ۉ&E�hle�e��\\���n�@<i^(+�\0Xqȫ�s���j���L�ȷQ��;�E@8l�-�I��T�N�FL,��f�:Ӝ��1�H����U�W�m�n)���0Ѿ�轒���2�M�;)=|<hX���saݙ�`)C����E\\��_�\'��H�h���Do�����#�(�@\07@2�gP\'��ײcx2\\Mr��Oy_T�7؛lNR���S���8�Z7�i���\r��:J���,�(�]����!u��q�����$hdU�5}���0����qR�k�W\\i�YS��;z�0�����j=�7��Gt�sZO�D��W���0�1���d��$o/@�~�,�\0������P�O쑆���=\'m�^0�4[f��eQ�I��C��Y3�����[�d�	]㽎�\\�!��E6�\Zs˱��\\-�F`a�N�N�ǉ��J�I�\\)e�U�:�|�O*F�\'1ԝ��jh�z��ߣW�2�p�����x�W85��.X;�`��m\\�����P𘧶fH�1άXB:�WL�FBF�1�?z����ϓ��1k��q�)ԍ<J���٭#fJ4�a��4:��:��Q�:��]a\rj�>��u:�s=��\rH���\"J�w�ևs\rn�!��4��U�[��΀�;�����(�+��\\��|��=�n��Q22�@���������5\nIG\"���$�#U1L8\"�\'2��j�\r�{Y�d\\���tش�Mn,s#s寽%�����3/�?j�n+iH���I�hR�9;�Q=`�ʔ1CPc�\n�\'��@&\\�\'}\'���л.�\r��Q��c˥%�b0���\0����O��S0]��[-�dQ���3?J�ņ�6Pδ�����En�`5�^J$H�z\nEs��\Z�dEUH�d�Ԛ�p��w�����M~������n� ��mT �{�\0zGg�Nn3hr����#�R1=�wP�\r�@\'11_\Z[����``\"�\0�Ү�;-�o�� *����4�w\\~Nb�fW�[! K\0���Z���Z����\0\"Ac��>�Y��\"��5��}��]�a�\0pbQ��Yݴ�+�j��2jc��U�}���J��� �����{w$�?���:��\'���f*��|�=���h�����\0?Zf���oҊ�F��V���l�S ̂�j\n]�t��\n{��ea!����\\#j�va��d�ܑ�ђ�4�H�Ȩe@|�y�r�$t��Ƴ�;��q.�a�n[Y��_ü7���ٲ͞����y�an7-\"���ph�6�(�<��\0��Q�#|D;+h��h~���s�YZ>�\'��ݏ7_3��D���Ҙ�{�E�@����(�o\'�5�\\\0��]�op�R޼��V���R���p@��\0z��L�\rF�Y�xn\'+�-��`\0�ӛב���\"5�9�Ҿe3\\]��1�A�$xr�<o���ȯ*�)�Iq�Zͅ\Z���dWz!x�¾����R9iH_��@G�0:zW�\\�|�x}��3:m�VI��0kE�؊�(7�4���W��a~����i1il-�$e�z��M6���vظ��N�N����<Wf��fa&5ڤ5�6��:��\'oi�t��_\n҂;�J����U��ѩ[�@�f��ҁg������8�=&��	q�b������6�<���=7�`���[�t|7��V~��r��	S�\0�x�^����h\\2�מ�Z��Ko��ˉ���C�S%`��\Z�9�᧽G�l�e������78v\"ѐF�ɯ�mά�o��@ 0��\r��Τs$�\nn���/q\r��\Z�D�y���K�S��(K�P��:s�7�Om�W0��!`DC\0dO���%���!fmU��D\Z����M2>��4�;�ia.N��6z�`Ȓ�m��1��x�J�~\'�����\0��xߟ�Qq<B�rmY$�\'}LM0c�Mز���$���>�����gvF�eM��$Վ�+:��C��Hv�h�5��\n�¸��f����\ZB���N�M�	>*�w�;Gy.����Lһ|Z�����E��E]x��}U�V�0��)\nv^��.�Aܧ/F�W\0Q����O��?���)�ytޭ���ݻ�\rt���0\ZN��+���]k��wD*q����	� /F�#h������ld�ȋ����HL�����b|y�s�L1ʣm��֭X>t�׮k�)���\n_�89pJ\\����a缏�.*q2 5w+�o�r�&w��V���0�{Y�\ZD��]t�RL7fq.{�c�f�VN٤�s���\Z.�uk�;C�+Gs�u��\"�fVѠ����q�����|b�_R�����PG9�sa`�\r�J��5\'��S׉�j��β��/��އ��W3�u�ف��6��?*M�lOø�?���\Zo����,+vRV��G���|_��r�k}�L��O\n�b�@A�0�m�h9~N���T��8�#���-�3t�\\�w�k�\ZԌ/g.H.ew� �&�W��ڷ��P9��>UV���s�e]��/���U���L�_`#댸{a���5�&*���-یa���P�Rۓ�R�����D)*}��+�rع$乡��`�uq1�d�O��F�ḏە0�|z��REčT�`o�ދ����p��d\'-]x/�c��Z5cԓTN�s�Ƣ��nU��U� �c��nk�����&&����B�*�@\Z�\0���C�Ys.4s=Eg�F��Aq�6�~�Î��h�2>�R�{����Ah�ҏ�\0;�����m!��<���xņ��#����/*d������п��L��L�4ː��B�v��C]Qqz2�t�G:�.�nۙ�7�=���N��-��ݼcX��\"3�+���x���ģ����:�U{�vU��\'@5 4��չxR[����j�MƲDm��[ז�ʤ��u޵\'���<yh�8�6���F@�c����m�N8?\0g���^q֬71�`Eˊ	��,o�)�q�h3�ָ߸S.�:\n\'[%�l���an���9Ye��\0\rF��Ҫ}��w��B��zm5��E��6��\'R:����G�L�va�[W-�1�A��iT�j�:bL~.\"\\-�0(�c� y����ܽaZ�:Α l|���{:m^S�˿t)�\'�WVő\n���>���V�=�À_�G��3�ĵq��9��� ��:I�\Z�b�e�]	����s�Zݫ��q�tr��PAR}�W_�a��%q��f�	c&LaL���<\"����-��C۸�Ú���W��8�������ە+Nˢ���u�\0��Fbu>�*o\r��\0YyF��m)22��e+�Z��\rs�%�K9K	ʤD�c6��zg|H����Q��u�):��>��X���z�\'aw�&�$]�eN�Y�\'Ҳ�Ls�\\�#��4��>�j�%߁������������r7̢5�I��{�.�pr���5�/v��8�x��Y���(��hf#ƚp�L��� О���<�+L2��:y����f�����k;�BDRK\0:~Ӿ��m@��ʒy�>uHl3#eu ��A���W���V�[b[8���V\r.�;��	�G�Q2m;c��x�|�D�3d�V��vs+��:n���hI�u��M�3Z\nr?�֤qKL�B\Z�.@HɹnC_�L�Y�����T5���-��\0�I�/���u;ז#\\�sfl���=gCl�m�[�ܫ3:���Ҝ�z�}�m���;��E��S�@�G����^�h�7��\n�V�]�D8����1��`���S�0Ds��\0ШS;���#�٩c�^;7�6�+����͏ !�4����.Kk�M9��N����� ��W��Y57pH�+e�o����T�r�T��_j�]�u��m[,�\'�����<m�D漯��$��jU�C�����WJ�pm�-v;]�!o�v%X��dzӋ�4�>=�\n\n�&APD�W��.>��v2>��z��m-ܘ\0(y\n�Jշ1r�c�;�y�=���I=�\'�QÂ@��\"�3	���f{pT�F��y�kX�\Z\"�̩��W3Zn����)u()�B���x�+��=�kV�f\00w��2)ŵ�6�f,���\nT8�$8o��\"\'(��Һ��\'iL��V���޹\r6�A�\r����#�7�6��lٙ���D���V�}��̢��\0+}��S����\0�C/v|#��4�*�r(����WIJ|6f�$������2�3�j�o�2X����L���6��AA��db[�j=)���%�2�\\�|U�\r`�{����)�\ZƤ�r=`�I�a2�a,D��N*�͹�#=�/Yt\rTL\ngb��_��P��Q9������[��,�t�K1�y�jh����P�H�Ž����f�Ǻ�H\n7f��!YT�z^��y���hRy(�4����*�I����{��]�2�r�9������qK���D�|��\Z�bpy��ei�\0Ki���>v����2��I�#c[2ț��υ2&M(,`�?do�gi�9x����6�w��yHx󢛎�\03-���R�xb\0<��\0J�[R�\"��a-���7\\u��\0��pi��nc�\\�\08�|��x�r�f\\&9�;\r�,�� �\rZߊ���-�fy��Q���A���8G,���C�����:E�Za���_޴��&4�?���ֲ2̪�\rm���{}�Ē;�I�gQ;υX�}��w�<Ѳ��44��`��з�UQ[�l�aFA���e�:�`D�xWX�-���V�`�^�7��ԿoU.5��`j���.n2�R�M@�D�;Zӭ�K��żW�\\�p�0��J�\'�[��� u�ڻ�\0��_���{��-pۅ��I<�@��\\Bj�;���K�g1����;0 >��qT�.�����H��{\r���ܙl���!R��b�e��j:����Q��-�-�%�/x�� ��msZ<^�0�ٿ�� �ӏ�N��΀������N��~Rm��V���	ڨ8�n�0�H</�ߴd�dܡ�5;	�#ƭ�S�.n�P>�*\'\r�[ev���\"!?SN����\0�=A�S}=fL��}�7�X�e�l��r�\Z h7�J-a]T�[���4Q���ݬ�J��Г�IޝZ�p谫�,��<�\0�.f;T��j\0����ۈB�\rY�N�\n��݋H�KeОRw&yɮ!��\"_�z�ŋ*I 3N��I=g�5Gi�;�Nà���k�V��Oy�2G�64|�}�v˥�D(�M�8ʠ�2y$�\0泳\r[na�hl>c�N*J�⸃�l�����\0\n����[�^�\rt�v��`������{�{�ª,(\0��@�;�\0�.o���X�w\'��&�}�����ٷ�w�,y�z:q��6G����n��\n\0=N��Ϊ�m�5c0>´�]\"�E�6f+G��!��*G·�޼�������b�{�j6�>��a��\0�zTde$�r�~��gm��m4�J��v��\0~���i-�J,�!�w0 ȝ$z�3ηoA�Q�\"@��^#�*mb���؅*��_�k{��{��4��I^���p3�j���A��t��Lq��FP!FQ�1\'H����Λ�0���g�	��EvE7G��a�H�Jl��WIH⸶�x���ʑ��H�cҥ`{HF�?zm�ë.V!��F�t�)?��uYS����e��F����O�Á�n��O�=�ۿ��ye�y>V�=�քoݷ�!1�q��|�g�G��On�\0��^�V�$��z�Y`(Ҽ��!r�;���\"���B߼�E�+�L�����&W�\'q�T�9�q�\r��Gּ��&�je��4��;�����ɦWe�#*�-�a�A�����k�>SF��3�Jێ��������z�\"fn\\<�{X=⨗�BgsB��<�ޛK���tv3��\ZA2���?SGm\r��&��8�S��&��R�|A����5��3�1w�6��Gx=G�B�����:i�������wn�[�yς�=�(��xF:�=ķ:���@����@9���\0�t���f\0�]��(��\n�������?UR���y�����j� jO�ܚB�ԓ����X�\0���k����6��\04yS���f$��f���<8,��~u��ۗvU^�@Z���C��n��*/jx��Y��]~���V�X��F�\0NuX�v��|�tk��wS��J�b/_�0m��PtPt��T\\%wy0{�@��Gՙ��%��f�&I�:.p\'\\�H�fj��0Jd\'�}\n�ք��5�O������̰Z���Iea�}�VV���\0�0�������/�\Zr�\\��=/�U!s+��w�N��A\0ּ��K��Du��M���)��\'H�Dj|�=�UW3\r��I������ߩr.�㬵�Kv�`�pѰ,��\0�\"|#\\S��b��Hm�g���Ϊ�\\Xqcb�\'�m�̙Y��1�N���ږ��؛z48�!����VL���GFO�V��B;�c�6�h�&`���f|\'&Fuj���im�<Gx~F�a��f۫�#�>ƃs��nS�g�4������9���n,HVu�t�>�	*�<����s��&JG���� �qԍ�~�O��ŏ����F���7)�f���_y~�{9o�ۣ��5�z\rQ�\0��px�) O��~���xa�G�H��J�ٕ�\0�\\z\Z�g���W>��?�#c�����X�����C��Ҕ����:�z��-�N�<U��R��XO�u�̵ n��]���~U���~[�C���)ǘ�\0�=�g��2ك��o0����<.~KcN��@��,{�KI�{��\'Ŀx���?�}i���c�<�~�{�u�V��0���2��◱|A����P�鮰��k�3],z���f��E�~�vc��L��wl��;ؔ��B�5^��5��6�\\<��=���&=����g�2}��g��S�\\��C�S*��c���\'����-���h�\Z<�_����f\r�wc�پ�j�m�.�0��+�ݴ� ��W�y@�?ө�O�~aNT+#�~�	���ٽ�}ɨ��\Z>�w����$c�G���R��L���T`���0t��딏%ui�Z!�VH���G�,6\"?�>��)�00\\\n?��\0)���q���3�\0�e\n��~��t�F��e���(��E �����Ē���J�k��\nPF����q�r\r����(�Ac�S�{=���\0$}ƴí�9u��[\0�=�.FU�M��G\Z���\0���f�CR���~�>�h8�+@u�Y�\0\n�t��c�Q a�;�;�����׻�xxg#�\Z�>�=��y���`h�O�T�򤮐��&�\'Yx�\r�֕�Ǔ,}`P�@P4�\"�b.��!$\Z�qs�\Z;��xI�κ�i͠:��b���8Q��#J��������.WS\n��B�V5�:J�Њ-��\0�߭rR�;u��\r�cNFM#�Gޣ��?��񷯼�V���WC���\0��q¥�>g��=�4��y;jqn�ɒ���P3Q��1���2=��K���?JT�U��#�����Bmd׶�f�|YO���cN��D���\\��E9�}\'�������P-�p[���_&��W��2Ø��k҉�1>�O֖�\0�|A߷l����;�;l!q�\\��:H1�Oz�E�-�\0��15/��V�	�bH�^�@��Ul ��ė���Ю��@����`���g�$i�aF��Q��f�h��0��|#���t\"�Vb�f/{%Ŏi�����U�l����&��^A�ﯞ���FmQA�$��� +\"c����P~������s��Q��\r���'),(3,'Кола',9.99,'Кола привезенная из китая но сделанна в США',10,1.5,2,_binary '����\0JFIF\0\0\0\0\0\0��\0�\0	 ( \Z\Z%!1!%*+...383-7(-.+\n\n\n\r-% &-/-5/.---------/-//-------/----/---------/----/---��\0\0�\0��\0\0\0\0\0\0\0\0\0\0\0\0\0\0��\0?\0\0\0\0!1AQ\"aq�2B����#Rb��႒�3r��$�CS��\0\0\0\0\0\0\0\0\0\0\0\0\0��\09\0\0\0\0!1AQa\"q������2B#�Rb3rS����\0\0\0?\0:+��+~|��6�E<QE��4E�\"M煢(J�E6��.t��D���.��b=�<��Q�\0�ֈ��\r���%�t�,�oy��G���YhP�.�|�:D�~���\r�%*����:�������JB:�\0�D��:�hZ��YC��t�@���l��V�n�˞�)[\ZF_m��\\_\0��/m�	A��y\Z��iiR�1�WmV�>[��q�s	p%̦D�	����s�4��_G�q\nx�y�ͬA�(�\\�4\ZlzO��\0:�q�֗�����׻�#��7ݍZ#-^S�k9�\0����%U�<E�S.�\r����X12+j�?�)D�5t8�\nXV�M1byH�H������M�+�-ݴ��H�����}��ʤ1P⹍��\Z�X�;3\\a�\'��Qj�`�`�ZHc��6�����Vfas8~\'����v��V�^�q�4L;��GCT����z/W��������Ȣ�=�L;aYr�n�U@e.#�Љ�Ҧ��nN�q�\\�P5[\ri�N�/�U�����_y�A�I{�5Չ���c��)�{����;�Ò�3�\r����Ğ�&�{�]L��[M	\0~�\Z�L\\��G�b����i���b�1g2A�4������l�uFWA=>���N�ː�V\n�3$�� �̫&\n�bpYfL�\'�v#a��@�;�*Hz�EckIZ��&�E?	��m�s\rG���E(�\"�Z\"KQv3D^��z\"[��Z\"U��\"݉Ԑ>�Q,Oi�6|&��e���=_\n��Q:��W��3\\fk-��|u�U�۠c%����{���)oM|�T\'9+ぼ&O >��x�k���6��Vч�>\';�bf�8�Iuh�3����e/����X��-��#���\0��`���MN��+����s�3{�~��d���uЏ#�V5\\G����=�`�;H�0�ڰ\\ޖ�\r��7��%����OP`�:��?�t�p�D�tz(��i�ʤ�OL�I�S\0@�5�w����a�#9>�?�ױ!2ᮣ��U�F���ގ$���ZT\\e�5J��{.U�T��lnZiQ�\'Ң5U��a�kA��U7h{CwU���U�ܓ�6�_-��J�y�.�O���s�a�C�_�C�Xk�A]&;6����ֳp��bݲ?S\'�]:��^��)�x�I��z�B�\0�w?����\'�Wo9�Ts�#������g�}�?��mq$�嶶�[����f���WTp��e��p�Uxs�K�6�5�P�85m޽�r%�kR~$�{̣�K�Њ�.n+�Qf%��\0zo�zʫ���6�DK��VF9�g#�\0�sQ���U�N�*��,a��9�E��Kj���\09����|FtG�:�� ;��[�|Q՝�jZx�����e����K߳�m��\08\'�ʬV�gQ�f�f�!���u�)��3�[�X\'�KgF��yN�*�]��\0���vI1\0���F�VѺ�R���\0�p8� ������{V\n�L}���7�\\q_(l�����0�^��S��^s�s$�c��!��ެ��䛅X�Ԫ�J�QFc�:�6�+�=��Ǖ(�\\U�ӝF�(��m�5��[�\r�uU��=I��X$\rV�iq��(\'��#��ïx��m�����\0����1mm��{�z�^�C�z�Ÿ�\'=��T�����\0��5A�����z�\'��ı�73s��(Ip�@GI�Ru��h+tCI���Yp�]Ʉ9G2�5�>j٦ҪץN%�|O�[]���.^	p�L��yF�g�����*�k��2[Ӗ��U>/N�����`�V ��ʴ� �W�C;EFȑkDxꈻ9�D�.(T2��ĝO/?.{��8�NR���Nh5i<���FC)9��;M]^T9�Br�*��*�։��Ҳ��v��pZ|�HD&K�N�\Z��WS�\0\'T���&.\\v>lO�����*G��kR9��,*~U�S]�&-N�_�]X�շp\\@�`T�\0e��Y�.C����>�1�s��.<�l��@݂ƛ8�W�6{FcB�D�\0�@���]���19�C��࣮�vh�/X��C#&y$J+��9�?�5ig �w^S��A��R��F�#���m�H����T�X������h����z\rE߱k��τ��}�W�3�3b���J�0;��H�\0�3�G\Z�Q�;�9@\Z�f9���v��-ʂV�>{L|�ռ�z9���o��c0l��S����\Z���]6փ{�{�9�	3����Ti�;aH��XL���Q��\0j����a�\n!��PB�`a��(����A���J]�\Zxb	p\Z�bm;뢱���H0��\"ͨ�4���Z*��\0��-Q��G��C��N��y��ncd�\0z�U��Q���@h��>J\"��ŋgPr��\0�X��6����\r芢�$��ʈ�[C�\r�㩝���S���lu��^�t25�}uR�)���]��~�#�S�߉�Y��Wq��:��+?£E�޹�+=�\0ȯa���|0�M�����TK��d��z$�]�f0�X�\0z����,��\\`uEX>�c�1h��sf�, ����h�U�a�E�ux��\rozLHf\']�pd2w�\\�Xe\' ����\Z��6�͸�+���V �BL_^�t���q�;6���WPo6D��K\0��\r�o��L�j���Gts�W�C^�mGHh��1s�װ;�!}��}��7x�a	K\n��|Q\0�D��]����٭��NjڐN�v��n7۪ ��V�%	�[�`�їI\Z#Q]\nU�!yn�\Z�J��F=$4Ԋ�(h��J�Y�!R�\"oۙkd�`�9Oڵ�ub� �f5I����KX\'�۔\'�j��k	�mQ���w�P��<�B��t\0,6*nU�1u𸥪~q ֞�ꍙG��\0��V�o�i\\�xn�k�Cc��*^�p�g�\0U.�ԎM�\\��ꨫ�-I�|1AM�ɶ���o$U�?m�#��~�D�es��FRy�L�Ow�#�f�m�����G����p��\\q����*�s�=���\\d�Q��O\rE���h���I�,X�X��G��Z���څ��O`�`� �\n\'Y�@�\\6�\rO��PO�f�F� �� oG	\"5]P�s#�~�e\r�.ʠ��o}��Q��Ў�Cs���Z(�B���hv޶�t�u�j�[V�S5�t0r��YL�@W,pX�G��)u��=Nվ�\n��O?�6�c|���΀�Z#9V8�]U�ҭX�+q`*\r}��ֈ�,g�A��Q;�b��y�Έ��\\V�\r;����Tj�G$^g�:��{�D�g\r��]�ĕ����W�z7��+Jw��7�~�M9�6�!ϰ�^��:XPS��\0����:�@]�:��h�	�6\Z�Öڳ��E$���|�p�M��ծ�m�8�ʸ�p��}m[�i�ۇ�AX�K7�@`cY]*f�\rw�4��1o�D�Ѐ�\"��@�#k����8����)�\n�d7[\"����R\"9�Y�)R6��U�8Lw9���\"[�Y��C���_�6\"ʌ�#��n8|���+A�$\r*�|�l��x>,V�N�@��1��bQ?�>%��BW#��\r���2βB��zT�K�.k����6vսK�}���Q2��`�0��d�Ԑ\'�:�9�f\n��\ZOq-���t1�������a.��o�ɓ\\��dLG]���U�Lp^���R�O��w��غ���M0���T�˕��#�]b�����Z�|�Q�#4��x~V��pWJ믟D3s��C@?�aI�(D�UB\0mYP7*&;���F�4o\"?�2�^1����k37{\'�y������\0�%�9�ulEVp�.�p��5�[y.�G�?�N�~��Q��ق���MEۭ��a,��+���R�~�\"������0����L����=�,��\0��~��<��ex�)\0��޹�gu�{�?�b����׀����?��?uhG&;�I>V̃;��W���A��;���|M�	�9��q̳,��\']#�r���u�i4R`c\0A<���r�ŝ|$�Ai��@#�|�v��G5Z�^6>G�\r�A��pt\"T���:V����um؊f͹;*�v\'ū=d��޷��36l�]8G.s�:V�T�������H�� �Q9�p�eB���Nڂ@����\05���/�?kg\"����}G#�RHZ�\r�/⵱kʺk�j�&���pmDV61��A҈�{U�԰����lNS���=ER�h����o����^K/��.^��n�g:N�9*��G +�P��J�	KO#�ܤ(��U�Bv������vUR��\rk��j�6�%�\0s6�Tg�;H�b���sP�ō�`�g)�n-��M���;�&OS�L�Mv����=����K����l\Zڳ�����3\"�	�T����F���u.����\r13g.i0H�h\'�v��N��g�@�ԒX\r�mzI:UZ����v��?�vzb]{�����j�L:{��T1���J6����m�m�/�k7S5��MؼqK깲�*��x��of4��Y�o�Ũ\n�I�-Ǘ�_�G+�^��	bQ�wr`�i��$���D͗�4��d-�X\\ǟ!a{�{tG��-��sn��2��9gO2N���a�DlV�z��Q�-����\Zs�[,��uvR!��a\0��C�{V���\r�B0��{}�����[c#�>zW_S3`�{��b�|��.����<���N��{�=4��%쑨ڈ�c�]��\0m���?��1DY��F����M�#D-9J7����O��`q�2����a��)̇�m���|�����7��]���1��\'ĄǑ*yΌ��zh���ic޳�+D_�&Lü��˨���z��l��+�\0�qNu��9�!?ڷ����r ���m���5\\�t��_���@����:|�����i\Z�}v�E�@ͺ��\Zxd���6�]k+o�����S#����Rd�y���R2�P���;;L8o����<\0.&���Ws�����*�4+1�H?�{���\'m=�� tc�U]ݝ?�/�X:~��oR�u�A G/��t���F�#��Vem�\r��G��/��a���\n�Vh����nZ<���d���\"]�\"����ڈ�~������B\'iE$�1c�MU�$�z��Q��SX^�I�5zz\r.�O�j�+n!�y-���W�,m���n����C��v!\n��s���S��G�w�^W��c1�g,�	��@�����������B(���K�|BI��ڴuW?��NC\n&3:E�\"ֵ�몢{f�.����q��iR�UX���g��D8��\rD�M��d@��i2b*8S9�������hbr�n�+,�4��j|���Y�R�py���t�j�n�t/����:`ɸ�]K�V+���;�`�!�:�mȈi͙�i� \r�C^��v�7 ��D@��ܠN����i���\0�:O�:���uN�������\r#���ۖ�r��X���m��N��}�����Vx��xw1�\"����Z��#ەv��lQ^�F��<����pռB�]m��v�\r�7TE���B�t@H�h\n�I���@�zMB�n_��Cm�T���3ے�N�y7�Tsc�z��#U�6\"MB�J����0J��*\rP88fj���S5�\Z����9:��:m�L�*E�H�9yI�\"DA:���-��x,Q�z�2�D��0��~ջBҵ!P[�{0����D�� o�\ZO�c�j�p�p$��T�XbX�(��5������	&��t������Q:�\0�K�����!�v��d��h�ץi�6S���\0��}����t�͔<e�b����$�{Q�y�̬��&���2�\n`h2�I�~�R���\\L1i���^���դB�HuҖ�y��ˬ�R�.��n���dtL:�z���Fb.Toi�5��ϯ�jE�k�6ӧ��+B�n�B6��\'Bt�Z��H�U�f�E�a��[�L�9a����ȍ4<�xdK�S�O�`�[>`؏����a��s��`2�]5@�fd������ey\'f���ܽ5��d�(�����ه�%YY�A[1?�|\'FsZ�`>��U�wӈ�P@�\0��离���g���ͰK$�f9Qb	�^g�UFR{�z�G���v�4;���h<\n��)n�!\n�S��YP��6 ��#�:�K�C]��\\LQ�Yըi\"v �:r���\\���1x�\"�&o�kΈ�{@{�����#�͡a�>�(K��gr�i��J�������z���T5)��t�X�L��O���XV���d�m��o-t5Q͍?��p�$��A����ɸV�آ�er��;Ux���$)\\H� �?Ҥ�VC���8\\� 	���:m��k~�\0k{$��#����\0x��ѧ�]��(�6?)\"$oYi �h����İ���,N���?�zmG̵S{��5LF�:�k�~�\'	=/�oz?���!�A�WӅ����\n5�h��Њ\"j\"��o�^\Z����aȯ���V���x=`Xi�@�nU���RT�j�t������	Ф_?�R	Z�$Nì�Q��&V��I���c�L��H\"S:sL{k�+g�D�O�BD~�\\=b\'��N�Z�+�u)�5�F�F����z�V�4��:r���Z�:,�괎�c�7���V0VS=�Ԗ��i)�U��c��^G�Qe:��F]&�K����K��5�0!XC�z%\\�u��W�5\0\0T��H��;�U&�����N�P���rdBr��\\./�\\(�ʀE����kv��c���Z����4h�H���Q]�-i��vma�Pt6nZE�R蝤��V���B>�\\v	��Dw��������sm�D�Ei\Zlv���A��&�����DA��Õl�J΍���DC�0jg4�@;\0si��Q7�3�ya\r��36�ۮ���Ԛ�웍WG�4NW�\Z�`T�s�R^c��B�^��F`�b��/h:+�+9��vi�\"S6a!;o�������gb�2�#�s<��K��2lߣ�Dϭan\0]��;�5��uƽk �*\'�O�*���R����D�G˸�ѡ\"U\n�2��|W,������!κ�#zĨ�0n�6z�+}����`N���_9N�O:\"�$0�*��`��4\r%I�ܾ�V�l�cXҨ��Jww\n��\n�^Εm�J��UWYvh8��Y[1�v�V�V�MӶ��b����eh��u�5���<��SY�\0�\Z�֟���6[)���1Ӑ��r�pp�����Ң!l,��&��>&�1���=��1u�&<cq��ƍqt���2�M�EH�6��iSu�Ӵ�/+E���q._G�����4��[SM��#e��R��/A��X�e7�K`n+\0�\rI\"c�kz����8s�q�p��,\"�ý��wX��R@iFVðîH#�j�`�7&��zz�Ա\r���x#H ���fGU;�|O=��Y6`5�?Z�������\0��}�~Ѣ�h�j���QDJQ4E�`s�q��#���3W�ɷsFS�u�&V�G͜�y���6#�`�QE��5��%������H����\Z����\Z��Lc�7o$%c�^dw�&C�`���S�t��Qs�gQ3����m;ǰ�\0��ز�T܁Q:���r���8{���1f�w���e֥\\6��p�޿~U�����*No��fB���5�V\n �we[rZE�>6�#�E����RQ�j���l�S�w������	�Kh��r��\0h\0��h��J�����%d�W`आ�G�j���8�  73�,+p9�ֈ���V$!��G�aQq>!�4\rv�?�h��f]��%.w�9^I�E:O���Vn��;���Ra.�\n�^�	ZU���fa�B}Z�����$\r��z�[tZ8�\r��b��z�[,W2�P\'R�#���T���� q|#��Mx�w�#�!��t�����\Z�}+V�]V���C����ҥp!�2���b[E�ۨ\0��J�42���tF�\0�}��x>#�����b\0,OU\0\r9��SѤ�w����U(9�(�ԍz��Ǌ6��l�r��BͶ�y����b\0\Z���1ʧd�-u�Ӫ1��Qٝ��I�֞�O����\08�%� �[e�\0�\nT�A�A9�d������.)�\"I�\'K̏)�0��Há*��!D��:���\\v�G��k<�������v������ 4:(�b����|:�W�㥎��@��\0Ɯ��>�s�XD[?�9=���ju�f�]\0iX�:�\rf�:�(x��V���V�;�� ����#@�I��<���+�r��k���7cm(�?����R]�xu$��DS�oe���ԞpB�\r�U�d\rm��w���bωQ�A������fJ�:ɸ��!n�B\\�*O�$	ڰD��)���c;k#/�����G�.�w��DN��w��Wj�~����\0����ؠ+�/a�w��r;�T�E��鰸�uۙ�~�Sv��5�R��D]����m����ߧ�V?m���i\Z�6Tx�f�7��[g�۳mm�P��\0��}I;�U�\rΫV}g����\r[(�?m�<�-���;��;�j��0��e�A>�E/{%����a�~�Y�U5�\"��p���H�%}F��a�B�\rW����rX�\Z�m\n���+Uv�IR�4����?\r82lu���e	���e�W����#���<`�jbz΃��{�*�\'q�U�KrB[�Fb�f	1��\rKE��q\\�/�JT����ˢ��@<�x,��Zr�T�Ȓ@=7�3�\0�;��g��gV�ǿt�l�Pچm��Di���Php�^�u\n4�9�\'x��:�?uq\\?y�wk���-�BŦ!��#C�jJ��I�O%���a��鴜���_0���\0d���ЋJ�9���٫/�Ҏ�\\+�y�C��q>B��]���\0�?���V4���Y2�1�O��*apg�3��\\RG�֊F���v�l��n����g�Z`A���V����\\�Q�~a�Z��J�O�������\r\rl۸�Ʃ��=>�Pb\ZM0F�]T3������8�-�qn2���	�������<���{�q��3f�*���,�����Х~�K�绸�H;�T4�r��\Z����!s1XwQyk�A\"�	���K[ᄃR*�.��\0\"��\'�4Es����p%����Q�י�A�c�EDgI��%���L�\"F �Rf<�y�n8��f_�̗���H=A���B�A�k�b|��!?m�7��&�q�4��G�Wu_��e�<5�Ok�t[~ʃ�{*/⻫7����HS�;\\�G���wCM��qC����a�g��m<\'kim�XU\ZG>��d���Z\Z /^���5*%K-5��(-c�@A���+����F�ڋUcz��DQ��W��ދ!A�֋(+���7ʙ;m�9}�>�ʫ�f빃�g�P�p�*�ڽ&��;L\r΃���ǁr�֑��b�饻#��_܅c�k�W�t���8T�8�j�e�\0o�[��~�y��E�$��\n0�H�u�c}{�c�o@\"lyF�r;+~%����ⅻna�5�V\\�N���mW�n�\n�t\r4\\�=\n�:���ږt�bG����W��8>�Ŵ��N�����j`2S�\\�V�&�l\\\0�u�p�]����ce���H��w jbcޫ8m0mk/]���趦,xi�X��v��~(��wm�z\rN��S�LS�^S��g\Z:4��_ρU`���l�%˘�8<�W2Y�s�b�<W��$��>+;��ώ\"ؑh-��D��O���U���y�8.&_��q�?���j��z�a\\I��y�b��\0 �;��5KN�?$�1��\0f�J�f�2�R�X`�d ʕ�=I��U����5��z,\Z�xC�\"�Zu���K¼�qWpͳ᭍��x2����zU�@~N�깯k�����T?���T8�Uý�\rے��d[�e�n뵗�x����P�B)��ר6].��i��Sm��#�\\�<->�_�$�1���]^d�\Z���g֋�o3�\0��DEV�P�`\"���`^�E�@ڈ��1�&�Λ��zfS6>���AY\'�s�b�-�͢�v�3}�T�:����3�7��-W�]����-�,ڻu1�r�zt�/5��;S6�h=��*EMX�](�R�҈�N\'��O-�����1��U�b	]����\"��Ѥ�&�\Z�tQ��-��#�?�.GȚ����89e�dh�u�ϗ��>�W��VЄA٘lM�yݴ>��|�u�U�-B6k�Ei?��q`r7I>�@�\0���^�u�/;�Xڣ��>\'����{ݍY���\0`��O���kS��v����\0�3�Q�?�0��3��w7V�x�ef�A��N�V���s��1*lv*P������E��`~(��6��o�$�D鹁���=Q,>�Ü��O���g��Ë]�5���V*?��X\0�#��U��&��z�=Q�;<#?���w�M�����a����F�\\�\n�bJ��Nѭ\\qht^6�:ƯgL�F���P#~&\\6�#�9�>o\n�$�+\Z�\r�Uq�$h�KL�����D^w�#��A*��\\-$� �:��=u��^��i�h�.P�O��ԥ�k�\"�i�@k��� ��*�\Z�-ז�)�qD���}F��G��b\rۙ!|D�\"T|^dʥv]J�4�y��7�x��/�\Z��,�/-��c�U0��9���UΩP��{/U�ö��%�C������\r�|B�%��혤!\0�\n Ao��@��y���0xl>������=�{�g=�\'1=�I��\rzo�j��\0�y��x\"��0={�=\'Ү/(D$p��n.�1�4XDb��D��D��D���1r�ڈ�8wg-ں�UB�����j\Z�f�%�)��6\n�͖;,�_Z�VV6p�<[�oDO��Rh���E������AX���E��]#53E��m�QX�DP�S�:\"��\\� �D@ݻ�%_�U�:��|�}��^�w]�^�	���W�|Dbl1�z�>Τ� !��/F���\r�]�Z���Ń��������?�=W+����P�|տa?T�y}ٟ���k��Uxۻ>&\\v�}\0B\\*ٳ±W����)��C\r�W?�zT\r�\'v��]�[�~\'E��`/1�O��F���M��t/%���#�eY��� �\'��4����y�\'�k��8�a-&Du������&	f�`v�.0:*\06\Z�cS�&��P?��k�`?o��0���9��A�^�?�ʧq�A\'�S1�N���Z�p�e�ܕlw��ڴ�G�_DMs�p�-��m[\n#�w���w1�TƝ&6�B�3�1Ub��\\v�@B\\K��r͓��U�����j�Υ2\Z��|\'kD�6=��c>���,f`�R�t�>EXk��\r�0Wk\n�F\\�򞭑�>ވϳ�U��wlxA!�����e�\0����@�5�.;\n�U�{�,d���}�;Wf\\b�Bm��\\��*I���x�\r�}xkὉ�[��ͣ_����%��2Á�rϟ���SΫ8ZWR�N����\0;t*����@a�R9@�cq\"���?��E�i��[B��+-�kv�ф�v�=���k�	_2�E�j:��W��#[(�����7^G��aY)�\"�Q{�ވ��DQ�Z�\"���P5w�\'�z��h��EKŰ�����8�\n$t����ጠ<�>�Ec�:Q�DL6\Z\"R[+�ވ��x%�Xe�D��a���5�$))T4���m�>S ��#���W>�a{,-P�Э���1<0^���72��9�T���)�\\�����[��(�\\u>�$�BLH\nˮ�����	T	i]�x\Z�q|��#��-닇����f`d\"\0� �v=+8���(�M�{\0�5�.�?;tw�p����մ�>-tP6fb6�����8�M<53R��Ğ]J;�����ʳq�\'��� ��v������R�����*��w)��7=LJ���]��^��t�1��k��D��[����������v��n��l\n��$�;\"�Q�V�X�p!tx_*e��צ��3�N^~q�����k��4K ��\r\'�������\0%w���Zh�p�Х��\0�:kb\\n,U<^��/m����Z=\Z��dO��e\0=คA@���m݃���p�t����\\);�u�v �_Y�\n��J6��\0�!�9�YO���T�e\"��L���=�G�C?hJ尌�H�a�΀�cʣi�awZ���k#���-lH��\'B���ԝǥt��/�y�8+\n�\\@>��E8�4����j��@fyQj���2�uqDWvu�r�\'Ep�2��E!�kDI�\"P�%�DI�(���E�!���XA�\0��e?����QeO¾�E�6h��b��qQ8@���\04Dێ��]Y�9���f�������L������-�2�+��\\�\\�(e��r\"[�+a�,+I���n!���/��u��%1��p�ȍk���ҽ����VhB��������H,��:���IM�y�����cia)��O���}�\'�v�����\0��|��!�Q������+=W\'\r����18��\0�6��Hj���\0Ϟ��U�e�ϰ��S	3\Z�u�zV��hZ몛��ԙ��O��Tohi����B�t#PD��빭��*)�T��s$�����v���	�m���an�,<1�L�I39N����O�<l7ԣ���;�mw*�qe}0�e\"�/�t\Z�A?����\Z�*���b<�����%q�,2\\F�6�X�Y���`����*��/���U�i�X�}�>��=������2�\r\r�\'A��@��@�U{��n-�Qo����(|6�G��\rl�^GM`��SRv����B�2�A�[�-�+x�Lhc��Y������غYԎ�3y�?�n�*�aY��ΫI�EX�������;�A�J\"�N�D�(�kDN\n\"�0*��a�(�?��>C/��\0j,(XvhF;�\'�����\"}\r-�J\"�q��s�&�G�k�C�W�#u>DH��\\$YM���+>��J�.(�N�~`wC�y�Ṯ����U,���}��x���W���\r�1�qz��	���ΣPK�sh��X7������p�;I��]����[�G���7<�:�Ru;h7�R�c%;�w	��~�s?`L��:�:zn���Ce�u��#(D�����_*YFfm�v��9���G��Zt*�kC�������N{Ͳ���נ:jGS��U�S�ȍ��y�J��D,���I[�����D�C̝+\"�v��Y��vWR�2,>T�|���GJ؁�(���X�8?o�U�C��T1gUP������L@�w����-�:L�\0�m��8�:EԈ�ξ4�|GM�T�̦<�o����\0��\Z<�[�w��H�5R��\'�\Z�:�uְ��������y��л��f��.�kH�,��ȫ�z�`�3ǰ �Vn�����}���mO-4���\'T| \n\"{=,\Z\"�.\n\"�m�-(��\"����%QDQe5u&��8�D�j,!K���\0�*\"��\ZQ�o:\"�D�m4D��G�4D�����3<�	#�?�+7u�ᵉ�o~����Q{W��VVV��+�I�R�7�֤j��\Z)H�cQ�EeFBx9�GO�.���K��od�M��9m\'Ԁ}&����U>\"�\'m�뿐�TqZT]+��6R� \0b|@3\0�>��L�:���Mz��:�T�L�|��`�堈��7Ҁ@��wr�{�k���i��\Z��e�YL�m7��\Z�+�>�^s�S4^*�k�#|����\",^��F��0��XFPC@���\\��&�^̇�49�o?E����j��\0���C)�����cک�A^��ejA�˚~Zcy���F+�,���rmGַiʷ}1U��\"t=y�R�X�rʸ�F�����f�{��h�u3��>.}�e]*���4D�y�DK�D^DR0�u�)�����(�TD�E��(�6ăDAcQ��h���%I1�\r��sEI�ݑDN�$]�(�NV��>�D����\n��Ӵ�ק/BkHRQ�i�9eΥ����s{U\Z�^�\rW���UWޡRB�m�P�\r2�<��H�Bo��\Z���v�(Ή�&7���?[VV�*�jF��۟/Z��[Tff�;AC�i�#���j���3�&�e�$!b���m$y���H&���N�(\\:I\Z\04�7��k-P�b���f�ي�Ρ|1�?o�D\n��J�����h��r��E�n�\0~�[9l�KP�̈R�yzՎ�ȜǸDD���N�����#��1�e��U��yO����Q�]NS),�N��2���\0�!˘\'��~\\�0�{q��9��6�-���YL\rz��*�B�:.\'�\Z��%���ZQWW�J�D��V��E�(�V�h��(�`����Y\\4D�Ţ*5�̦�;�d�y�∘�x��	��QDV��Eɚ\"A�HE!qϠv�,��C�]4���?&��[���+[/%Q��T���0�U����.�\'�R�7��5�J�n�@�\Z�8������pB�gh�y�\"\0���.�������3�E(���ۉ�9~�f�T�O,��r�se�N�x�<�ՐL��D����A�����=�kD��4X��1�3�L�L�sZ�)����e��=�����&\0b\n*����D�ְ����|K)����R|����b�i;ZWUpj\\)\Z�H�!�֥u�{.-\"[T�����7<������b�A��&d)�zuU4+��a�L��-۷\0�m������1�egS��T��&�i�}*4���|O���[���� �C�?j�	���Tɜ��d�j��,5,1�.w�t4D����\Z\"�����ڈ��.�*h��D^4YI4EjEv����z�ag�[Q�(҈���oɧ���?2%y�,¶��И�X]��k��7ӧJ\"��<�`��m=:{����P���f��� �qc�T����><Վꫂ�P��[j�t�d)������H[�4�m�gU�l�]#Q���t�h�z(X�R\'A>�+R7J͖®��`�\rk%Q���O���������#3|�����p�.ķ�Ē:��[�\r>Jσc����hʏ��>���i 8�j}��\Z��}�(�	t��Ws���e����+0�H���k\'Z�Nb\r�e�}0i��vA����73�\n�ط�s�[�Ȅh�q��5T�u�jVዌ����(�A�t��.��D-[�o%�arQ��y�:�ֆ��֯R���q\'�HnU��:�DJ҈��qDLf\"����\0��\Z�a<�∜�DJ�D^YJ�.\Z\"K-Vq(a�����%F�cҋ\n���[*G�Q`�(���aLKd�t�%�p:�Њ\"\0��E��ƥ�6��#����j�u���Of|��\Z�S{W���V ����q���^١vp�ڃ��F�jb���h\n�6O�s�u���ke�{�r#o!�_Ѥ�\\6	���-���V͛�[zU�\0��G��K�\\\Zo�����D�3����M,��#5Ө����[9�)X��D��Ỵ>)���\"Ar<�xG-�ڦf�2�.3�*R�0�y���-���Xt�bڠ�������u�k\0��\'[��\\I���X�X�n��Qn>���5���h����DI	DHkTD��4E�\'j\"�VR戮Â4E�\"��'),(5,'Чизбургер',9.99,'Вкусный чизбургер сделанный из мяса и мяса',10,1.5,2,_binary '����\0JFIF\0\0\0\0\0\0��\0�\0	( \Z%!1!%)+...383-7(-.+\n\n\n\r\Z-%/-/----+--5---------+2---------------------------.��\0\0�\0�\"\0��\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0��\0=\0\0\0\0\0!1AQa\"q��2��3BR���#br�4C�������\0\Z\0\0\0\0\0\0\0\0\0\0\0\0��\02\0\0\0\0\0\0\0!1A2Q\"a���q������#BR��\0\0\0?\0�3\'3Z��*���p�5#M:\0\n Rm52�XPR̕Eu ԀD`I��)�������қh����En�E����Ϧ��j ��Y\nm)�i(�J�C��@P��<��DI�\n�5c\"�B*�C!�@%\0M��*�(��\"J	 D�4�$j(\Z��;T��ʩ�D��J\"���C/j�Z�JdX	�1r�)\0@�.�\0��\0�MȠ���ڨ�Qy�Q{���R��ĢƑa�R��PzoJ�E�Ҕ�éQr3�,�2߇�~���I(��٘)���z̅B�dĄ�P�3\'�%�=�������ӪْH(3��TG�G2Ё��P�Q��M�,��@ȢZ�֦!H��j�#9��|�nb3\\��!�\rR� �R�jv5Y-\nLh@X\0��H\Z�hS8�\'���i����	ː���2��5J�F��A�TMX��ʫ����8�8���%)(\'@)�+R0�4��L��`J�d�$@}TW5�\0A�PFm)��:y����NFz�~F��\0�@�ɚ8�ȸ�˃��L�\0y\'�pݞ�<H`h���j��	m!�\Z-\'s�u(\n��m-�?e���������O��ي��c���\0ʋ�9��hk�LP����ZNfF�����Rs\rJn,i�0�������=�\'[�b�\0I�7o�O)�N�߉�y�>��p���k�h�� ��D�E�9Ht��QU�?�J�D�Uٞeި:��=�ü�	&� �5�\\�?�.i=ۃ�[C�]P�qK��3��q�����V��a�-<��	];3\"R���s�z�L�z��g�Q$�5��D)e\"�\"�H��6T�9�E\0R�2����tڬ�\n�B�I\r;Z�Lj�H,���S{�4�I���櫴e����~k��Df.��i��q��°��S\r\0.�sܭ\\#c�����\0΋��/-�=-��L�|�n}?ˣR�2�b-�@�Щ2-#X�V�FqO�g��J�BM2|MN�*֢@\"�]��|�%�)�/�PeާU���i��\Z�Ɯ�J��h���\"A����2�%�v�M��2�=��3A\'�m���vU��8���5n�\\ﳆF�L\rN����7�r�2`h6�z�Ym���bo���\'�I�~C���s�Ȃ,Nmb��^����&�s�<�����u�?呹I��k��l�73��u�c����6?����[�f�ߢ�����.6�I�X�v9��S_�)�Q��$rQ.^���8)�K:cQc��\\�R���,ʃܠ��%Ac�IR@Y�*0AT�\n(���A�ԈT�#�`jS��aVaN�X����Uj0���c��(�ap��\r����,�ܝ*�kgg�a��p\'Ew\r��`���+��p�J�v0�.EG�j���<�*�x��G��|M�#B����\0�������U���z= �\r�yE�%A��e�\r���l/j���.�g�i�Ǎ�I�\Zkn^˥�\rP�	-�u�Z�\0�o���#�Qs\0q$�gBy�u:�Þ��nd�(R�b1Di\"��O����(�k�T�\"�s�:�-\'��G�k^ �\r��G����N�l\0�D2PqX��i��s�\0G��uVh�Zu�q7a�0=eg?A1��:��#K��iɜg�]���}r$oyR�����I�8����\n��	(}�%t�ne&��df�/$�]�0���Vy����-*�j\nA� �23�����E���aZ���E�YTc�<�ZY�$XQ��pR8��i��w�Qk���@��ʘ@�s�ԙĖ^D���x�+8�/��,+c�����}�I� KA�D�Qm�&�����I�*f{�i���.xذ\"v �c)�s fh�D7x ,��c�\00D��q�\Z�_Vi�$�	637�|���\'J�kN�͜oAh������e�jL���\Z��*;M\\�L�\r�Dn6��Tc�	�h-p�&���x,*��u�N������m�R���~��m�����]݊�g�\08w�s��0���Fac��J�n-����u��&ok��W��@�;���p�ʌi!߄�1$67\'���C��__�c�o,|����s�5�����M��2��2�9@U���>�F�.��nqk�8��D���Z��\'u����x@��V�-�jzߑ��~ӕsd��0��4:����U[�o�F��B���sN���.����j��\0�t��b�\'{�!�kԦ�/`�~2�ۅ<7��� f�}��k}0��e)�\\\"��ē��Z}hWh�)wy*��h���E��?���19��Þ^�͓���z��V�D�F]�r��K*l�Rxc�c�*�j�j(-���RY�JIPY\\\'\rG�O��+\0�JmS��GH���\"��C��T1�J�֥F����Uc�gs\\[k�f/ou\r��eF.MEn������i�Tff��Mõ�I7��xWf�\Z�{��\r�0��V�2C�e @�Zgi�[�|N%���X�&|���Qrr�,���+E�e}��w�)m�Q2;��U���\r�%��|3�@�`V�p憐\0�ϊǧ�f���^�p���Ks�.;�}V���Rf�I��|^2�v�����2����)�8T��!�$�K\')�p2��-Ѯ!�w z}4Tx5�:�L�kZ�\0�H�ZAGT�r����J�5F�x�1��=�) �sg{D����[I�	\"�Z��$���U�U��,����@��+�΋��\rWS���X�\04�h1��CT��|\rn�g�\Z�8��7�mb>!�W7W�9��f�XE��}C����F�ZD�Z�0f�\0m�YUq���XnIm�i�j�Z��-.J<I�vA #+Σh�rD~b���] N���h���2Km�A��K%�b��\r�Z�iyM��D��ЛQ:\Z�\0��\r���A\"���U�����I���s��Uv6p�:k�S�/�Ie�r[����v3�4��0�^GUFA�*^&�nߢ�ʽ�oΖ�S3�MCAbsTr�($��v�*I�;�PWM*�`S�r���@@UF�S�KϢ�i�pcwZ�``�=�\Z�rti��\Z	;\0	>�-�\n�g;�H&�����fx��9�k�\0؏#��z�\Z�c�a���.\r4� ������-\Z8N��\0[�]2��Tg`��P>2�GB:���a9�ٞj���n�y2\r�t�����2�Aq#��1ӧ��ih��4:�*^#f|��X1�z��k{������������_���{3�3Qu���lٟl�#���ض�a�T����1���9i�����f����Yw8ų<��:���0�9��\Z�\"�Ps\r��B��#)��o�˨û������Kj�e�朒H{�ke��[6�����c7v/p2a�A�h��ֿf�o!��H@�q\0\r��T��j\0���&M�\0 3-O{��̗W���[�>�l���-� ��\Z ?�b��x�C���]����j���\\\Z�R����G�ݟ��\Zg/��پ�xj�W_j��spN(�R{*4R�32$��`]�h1�����%αvұ�MG5���e�����Ʌ���4��`�~���S�+��|ɟS����Rⵚ�|..\0omD�dE74�nC�d�\'r��T=樤��q.������ت�\0��\0�Y�^�qQۓ���g��8��1���L�-�+�X�`��\"M���bx�7���#�.��Tj�g۽͞(��v�m5͕��1�u�s�IYom�ĚT,�{+�=6���Ci*�%1�A�D�Ε4U�ʒ&b�=,VV}s�Ƹ	Nѣo�1q:����\Zj_u<�LgEZE`�7)��>buN)�����Ǥ������Aғ<�������;�φ���� ��#�y߉E茗ft��ji�_�5�|� ��V��M�?i�<�\"���l�&�<_Jm����A�Į�mq���щ4����2b���Yn�w�K&��k��@�����;s:*�35�<��.W��5L�en������4���6�\nz�*�\\�cw����j\Z��:���l?��\\~%�&t��/�\'=1W{�.L����O+Aէ)#��N1�s��4�6��&���{��d�7�	3X��8��\0L���v�KҞ������	3��b|�V-h�\0ȕ��q���������Ź�}����Ņhv���\Z�\0�=p�W�^=ٔ��8��\0��fJ66�gO�����I�$�6n��,��T�	PL� ��c����*)��h�X)݈Y���-���Q�\nH�!�3�\0�N�j���5&���9A�Sc��@z���X����4KI��#{خ^��U�i�O)��N���o�ogQ�\0�p�^ۆ�^b/`䵪\ZH�k\\:5��/?�p`Hn\n�S�?����\\�=�lv�|�: ���cN��h`�\\�ƭ���\\ɓ- e��sq��kVɍ?�aSw�O�O�����}YwTt,���W�s��G����Fʖ\'�~\'3����^K��\0���ѿG~�Tw��)�G�����~�� >&������)�����`T�8���@�\0��S�\"%�ЕQ�>d��\'W��1��p���aq*͠ǘ�[������UÞ~\'��tc�9�fR�Wb�#��2E�^K&�8�ᘝN����=}ԛÀ�v��%�Ȁ|�#�\n}�]*,�ʉ�]]�OK���ʮ\ZAG\"zBʹ�j�U\n�_mѤ,v��7�t�H,�+pf�\\���N���u�S��n�1�\\@�S�W��o����i�/}9AD]ֲ���WQ�����n\\����m�U�����K�\'[8~��\"�H��\0q�~k�����XL3�2�q�#�\"zI�^��^%r��B�+����H�RA��� �B���g0�E�G�P��v)d�R���\rQ�g��Y�Q��k����g�\\}F)5�:1N)�uu�ƈ/p���@��^�3�c���I��H�����N�^�N��W�aLl�3��\n�\\-�����I��b>� �X�������حbٓ���*+Njj�6Ch�JN)���y�֪�bI<�Ϫ�&Ch�*R�a����Sw��\r��-Hr$�T�kZI\'6����Y�q�\0�:[Q�D:B��1���^�Z�Xո��\0�-MeZ���o�V�L��b��_c>k6�*I�<��W�p\'.�䴰�9��PN��=\nM6;H����[��\0c}��ZX��u7T$�%��Ѵ���Ks�(ScX� Aql��\'h7s\Z�@�V{7Ý-sZ�����Ü��O V���0I/ Ƭ�Zuޡ.�\n�3l�oa�L�,ִ����̓�ϯ�)��:_F	�;�����*ZuI��E�I�#xGzې5�D�#-��rIn�7�8���N��=�4���&{qt�9�q���X�������[�R˜I�\'��<O����GK�b��a�͉�`�!�*�e}���%�A�]S�5�,\\@4-�=��A�`���3�12��eud�k��0����托��rN�ӱ�.sj���K�N�\'�װ4�4>aI��H��hJ0lƯ��Ԏ�,%��~jg�a���E�Ǽ�\n<�����]W���i���@::y���*���un3M�8��A\'�\0qG��<Sm�@��\0���tu8>���9O;��SI�R�Vۜ���+��� ��m�������m?�S��&�U�C�5�}�-��~\'9��\Z�	�H�1�.^���$���]��cKZZ�&A�#�%��\0��.�(�\'o�uG#�ʄ����Ӊ&̏&�ϸ��jTJ-\n�[V�.I:��vSRG�R����%��R�f��楎9�^��\n}F�aa�&��PLH��G��Z�vf��|N�����¾4iӔ\'ô6��gЏ��RЃS8�|1vP|&��\r~K���Z�a��v�]���9� ����d�D�R�P��\\[qaS�K�hs{ 5)��i�u� 	ӟ��S\r�\0ceq��$��[GD*��~��3��d�L�ʿf�=�K+���$��vΣ��؞��(h�M�D�\0�*�\Z�3����G;��!���w�~|���<�^1\'F�TU���\'�4���\n4��j�V��I�����l:��Xv��a\'c�zQk�\Z��y��T��y�u��c�$�8v��fs�~���J`̠���9 ���������3I�����5O�&��\Z��Ui_K���&����Qu<��к#*��+`���-�r�{N�`e�i�AA�6�\\��_X7`l��>Ɛ�s��xH�0DH$����G�~��N�@�0.\n�ꍘ����|�՛6��M�ע����9����<�*I��l�[�LN�}�M6�� ﲵ�q�`�[�C���k,{E��4��$=k;�9{&%OP�J���\r�F݉�m�tf����p��F��S`��\0\ZN�(Q�p�Z�\r�	�*x��G0tR2�&�LC-�o�!EP;I�`q:`�0�.���L-:�����/NO̾a��\0ox߈f���	$�\'i�J���(ZG%�1C�c�I�I(,��~��M=RI$t\ntu>I$�q0�c���\0$�TI���o���?���(�RQ,>�:KBQf���W\Z����\0�������7�w\\k�����$�U1`>��*?I%R�r��B�݄�,��E�YF����$�I�-�A��Ik���������̼Gݹl��7I%�O4M#�fs��I%��D�I,�?��'),(6,'Пепси',99.90,'Освежающий напиток на лето',10,1.5,1,_binary '123'),(7,'Грибная пицца',99.90,'Пицца состоящия из грибов',10,1.5,1,_binary '123'),(8,'Пицца с ананасом',300.00,'Пицца состоящия из ананасов',10,1.5,1,_binary '123');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `adress` varchar(100) NOT NULL,
  `number` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
INSERT INTO `restaurant` VALUES (1,'Папа пицца','ул Зимняя','9343425'),(2,'Кинг фуд','ул Глазково','98734543');
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `photo` blob,
  `password_hash` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `number` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Иван','Алексеев',NULL,'$5$rounds=535000$NHnSHjNuQOSQbT/0$7pEGjQrRL79yGdgXZw5OSEFQmObdUvfxvHHXtR/oJBD','Ул Липопова д 90/7','8792342'),(2,'Петр','Сергеевич',NULL,'$5$rounds=535000$DwdQq4MU/UryMp7l$NnjSvtvWK6QAv0t5s18QTZqIdGWI8i9yFT.aL5EI/pA','Ул Лукова д90/7','798234234'),(3,'1','1',NULL,'$5$rounds=535000$lk2HBaskQOr50O0h$4VwWVHEqoacDDzpYWHYIw0wNMHl2zNmlsHlQ4DNICi8','1','1');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-08 12:41:22
