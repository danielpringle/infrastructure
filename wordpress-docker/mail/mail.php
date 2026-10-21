<?php
/*
 * Plugin Name:       Mail Hog Settings
 * Plugin URI:        https://example.com/plugins/the-basics/
 * Description:       Configure PHPMailer settings for Mail Hog in Docker 
 * Version:           1.0.0
 * Requires at least: 5.2
 * Requires PHP:      7.4
 * Author:            Daniel Pringle
 * Author URI:        https://danielpringle.co.uk
 * License:           GPL v2 or later
 * License URI:       https://www.gnu.org/licenses/gpl-2.0.html
 * Update URI:        https://github.com/danielpringle/mail-hog/
 * Text Domain:       mail-hog-dev
 * Domain Path:       /languages
 */
/**
 * Configure WordPress email for local development.
 *
 * Routes wp_mail() through the SMTP service defined by the
 * environment, such as Mailpit.
 *
 * @package DPUK_Local_Mail
 */

/**
 * Configure PHPMailer to use the local SMTP server.
 *
 * SMTP authentication and encryption are disabled because the
 * local Mailpit service does not require them.
 *
 * @param PHPMailer\PHPMailer\PHPMailer $phpmailer PHPMailer instance.
 */
function dpuk_local_mail_setup( $phpmailer ) {

	$phpmailer->isSMTP();

	$phpmailer->Host        = getenv( 'MAIL_HOST' ) ?: 'mailpit';
	$phpmailer->Port        = (int) ( getenv( 'MAIL_PORT' ) ?: 1025 );
	$phpmailer->SMTPAuth    = false;
	$phpmailer->SMTPSecure  = '';
	$phpmailer->SMTPAutoTLS = false;

	// Use a predictable sender for local development.
	$phpmailer->From     = getenv( 'MAIL_FROM' ) ?: 'no-reply@demo.test';
	$phpmailer->FromName = getenv( 'MAIL_FROM_NAME' ) ?: 'WordPress Development';
}

add_action( 'phpmailer_init', 'dpuk_local_mail_setup' );