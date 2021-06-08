CREATE TABLE `cart_storage` (
	`id` varchar(191) NOT NULL,
	`cart_data` longtext NOT NULL,
	`created_at` TIMESTAMP,
	`updated_at` TIMESTAMP
);

CREATE TABLE `transactions` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`number` varchar(191) NOT NULL UNIQUE,
	`cart_id` varchar(191) NOT NULL,
	`cart_data` longtext NOT NULL,
	`amount` DECIMAL(13,2) NOT NULL DEFAULT '0.00',
	`mode` enum NOT NULL DEFAULT 'COD',
	`status` enum NOT NULL DEFAULT 'Pending',
	`meta` longtext,
	`log` longtext,
	`created_at` TIMESTAMP NOT NULL,
	`created_by` bigint(20) NOT NULL,
	`updated_at` TIMESTAMP,
	`updated_by` bigint(20)
);

CREATE TABLE `orders` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`number` varchar(191) NOT NULL UNIQUE,
	`transaction_id` bigint(20) NOT NULL,
	`amount` DECIMAL(13,2),
	`customer_id` bigint(20) NOT NULL,
	`status` enum NOT NULL DEFAULT 'Pending',
	`created_at` TIMESTAMP NOT NULL,
	`created_by` bigint(20) NOT NULL,
	`updated_at` TIMESTAMP,
	`updated_by` bigint(20),
	`deleted_at` TIMESTAMP,
	`deleted_by` bigint(20)
);

CREATE TABLE `payment_request` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`transaction_id` bigint(20) NOT NULL,
	`request_type` enum NOT NULL DEFAULT 'Payment',
	`gateway_id` bigint(20) NOT NULL,
	`gateway_request_id` varchar(191) UNIQUE,
	`gateway_request_data` longtext NOT NULL,
	`gateway_response_id` varchar(191) UNIQUE,
	`gateway_response_data` longtext NOT NULL,
	`webhook_response_data` longtext,
	`status` enum NOT NULL DEFAULT 'Pending',
	`last_requested_at` TIMESTAMP,
	`created_at` TIMESTAMP NOT NULL,
	`updated_at` TIMESTAMP
);

CREATE TABLE `payment_gateway` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`name` varchar(191) NOT NULL,
	`description` TEXT,
	`api_key` varchar(255) NOT NULL,
	`auth_token` varchar(255) NOT NULL,
	`webhook` TEXT,
	`salt_key` varchar(191),
	`created_at` TIMESTAMP NOT NULL,
	`created_by` bigint(20) NOT NULL,
	`updated_at` TIMESTAMP,
	`updated_by` bigint(20),
	`deleted_at` TIMESTAMP,
	`deleted_by` bigint(20)
);

CREATE TABLE `transaction_payments` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`transaction_id` bigint(20) NOT NULL,
	`mode` enum NOT NULL DEFAULT 'COD',
	`note` longtext,
	`amount` DECIMAL(13,2) DEFAULT '0.00',
	`customer_id` bigint(20) NOT NULL,
	`created_at` TIMESTAMP NOT NULL,
	`created_by` bigint(20) NOT NULL,
	`updated_at` TIMESTAMP,
	`updated_by` bigint(20),
	`deleted_at` TIMESTAMP,
	`deleted_by` bigint(20)
);

CREATE TABLE `order_items` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`order_id` bigint NOT NULL,
	`model_type` varchar(191) NOT NULL,
	`model_id` bigint(20) NOT NULL,
	`name` varchar(191) NOT NULL,
	`price` DECIMAL(13,2) NOT NULL DEFAULT '0.00',
	`quantity` int(11) NOT NULL DEFAULT '0',
	`amount` DECIMAL(13,2),
	`status` enum NOT NULL DEFAULT 'Pending',
	`scheduled_slot` varchar(191),
	`scheduled_at` TIMESTAMP,
	`scheduled_by` bigint(20),
	`delivered_at` TIMESTAMP,
	`delivered_by` bigint(20),
	`created_at` TIMESTAMP NOT NULL,
	`created_by` bigint(20) NOT NULL,
	`updated_at` TIMESTAMP,
	`updated_by` bigint(20),
	`deleted_at` TIMESTAMP,
	`deleted_by` bigint(20)
);

CREATE TABLE `refund_request` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`payment_request_id` bigint(20) NOT NULL,
	`request_type` enum NOT NULL DEFAULT 'Refund',
	`gateway_request_id` varchar(191) NOT NULL,
	`gateway_request_data` longtext NOT NULL,
	`gateway_response_id` varchar(191) UNIQUE,
	`gateway_response_data` longtext NOT NULL,
	`status` enum NOT NULL DEFAULT 'Pending',
	`last_requested_at` TIMESTAMP,
	`created_at` TIMESTAMP NOT NULL,
	`created_by` bigint(20) NOT NULL,
	`updated_at` TIMESTAMP,
	`updated_by` bigint(20),
	`deleted_at` TIMESTAMP,
	`deleted_by` bigint(20)
);

ALTER TABLE `orders` ADD CONSTRAINT `orders_fk0` FOREIGN KEY (`transaction_id`) REFERENCES `transactions`(`id`);

ALTER TABLE `payment_request` ADD CONSTRAINT `payment_request_fk0` FOREIGN KEY (`transaction_id`) REFERENCES `transactions`(`id`);

ALTER TABLE `payment_request` ADD CONSTRAINT `payment_request_fk1` FOREIGN KEY (`gateway_id`) REFERENCES `payment_gateway`(`id`);

ALTER TABLE `transaction_payments` ADD CONSTRAINT `transaction_payments_fk0` FOREIGN KEY (`transaction_id`) REFERENCES `transactions`(`id`);

ALTER TABLE `order_items` ADD CONSTRAINT `order_items_fk0` FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`);

ALTER TABLE `refund_request` ADD CONSTRAINT `refund_request_fk0` FOREIGN KEY (`payment_request_id`) REFERENCES `payment_request`(`id`);

