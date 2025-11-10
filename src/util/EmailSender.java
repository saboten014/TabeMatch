package util;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailSender {

	// メール送信設定（環境に応じて変更してください）
	private static final String SMTP_HOST = "smtp.gmail.com"; // SMTPサーバー
	private static final String SMTP_PORT = "587"; // ポート番号
	private static final String FROM_EMAIL = "aresuperionl@gmail.com"; // 送信元メールアドレス
	private static final String FROM_PASSWORD = "mhtjawmqubsvpeep"; // アプリパスワード

	/**
	 * 店舗アカウント承認メールを送信
	 * @param toEmail 送信先メールアドレス
	 * @param shopName 店舗名
	 * @param userId ユーザーID（メールアドレス）
	 * @param tempPassword 仮パスワード
	 * @throws MessagingException メール送信失敗時
	 */
	public static void sendApprovalEmail(String toEmail, String shopName, String userId, String tempPassword) throws MessagingException {

		// メール本文
		String subject = "【たべまっち】店舗掲載が承認されました";
		String body = String.format(
			"店舗名: %s 様\n\n" +
			"この度は、たべまっちへの掲載リクエストをいただき、ありがとうございます。\n" +
			"審査の結果、掲載が承認されましたのでお知らせいたします。\n\n" +
			"以下のログイン情報を使用して、店舗管理画面にログインしてください。\n\n" +
			"━━━━━━━━━━━━━━━━━━━━━━━━\n" +
			"【ログイン情報】\n" +
			"ユーザーID（メールアドレス）: %s\n" +
			"仮パスワード: %s\n" +
			"━━━━━━━━━━━━━━━━━━━━━━━━\n\n" +
			"※仮パスワードは初回ログイン後に変更することをお勧めします。\n\n" +
			"ログインURL: http://localhost:8080/TabeMatch/tabematch/Login.action\n\n" +
			"今後ともたべまっちをよろしくお願いいたします。\n\n" +
			"━━━━━━━━━━━━━━━━━━━━━━━━\n" +
			"たべまっち運営チーム\n" +
			"━━━━━━━━━━━━━━━━━━━━━━━━",
			shopName, userId, tempPassword
		);

		sendEmail(toEmail, subject, body);
	}

	/**
	 * 店舗アカウント却下メールを送信
	 * @param toEmail 送信先メールアドレス
	 * @param shopName 店舗名
	 * @param reason 却下理由
	 * @throws MessagingException メール送信失敗時
	 */
	public static void sendRejectionEmail(String toEmail, String shopName, String reason) throws MessagingException {

		String subject = "【たべまっち】店舗掲載リクエストについて";
		String body = String.format(
			"店舗名: %s 様\n\n" +
			"この度は、たべまっちへの掲載リクエストをいただき、ありがとうございます。\n" +
			"誠に恐縮ですが、今回のリクエストは以下の理由により承認することができませんでした。\n\n" +
			"【却下理由】\n" +
			"%s\n\n" +
			"ご不明な点がございましたら、お気軽にお問い合わせください。\n\n" +
			"━━━━━━━━━━━━━━━━━━━━━━━━\n" +
			"たべまっち運営チーム\n" +
			"━━━━━━━━━━━━━━━━━━━━━━━━",
			shopName, reason
		);

		sendEmail(toEmail, subject, body);
	}

	/**
	 * メール送信の基本メソッド
	 * @param toEmail 送信先
	 * @param subject 件名
	 * @param body 本文
	 * @throws MessagingException メール送信失敗時
	 */
	private static void sendEmail(String toEmail, String subject, String body) throws MessagingException {

		// SMTP設定
		Properties props = new Properties();
		props.put("mail.smtp.host", SMTP_HOST);
		props.put("mail.smtp.port", SMTP_PORT);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");

		// セッション作成
		Session session = Session.getInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
			}
		});

		// メッセージ作成
		Message message = new MimeMessage(session);
		message.setFrom(new InternetAddress(FROM_EMAIL));
		message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
		message.setSubject(subject);
		message.setText(body);

		// 送信
		Transport.send(message);
	}
}