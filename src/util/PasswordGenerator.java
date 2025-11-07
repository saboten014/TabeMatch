package util;

import java.security.SecureRandom;

public class PasswordGenerator {

	private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	private static final int PASSWORD_LENGTH = 8;
	private static final SecureRandom random = new SecureRandom();

	/**
	 * ランダムな8文字の仮パスワードを生成
	 * @return 生成されたパスワード
	 */
	public static String generatePassword() {
		StringBuilder password = new StringBuilder(PASSWORD_LENGTH);

		for (int i = 0; i < PASSWORD_LENGTH; i++) {
			int index = random.nextInt(CHARACTERS.length());
			password.append(CHARACTERS.charAt(index));
		}

		return password.toString();
	}

	/**
	 * ランダムなリクエストIDを生成（例: REQ20250105123456789）
	 * @return 生成されたリクエストID
	 */
	public static String generateRequestId() {
		long timestamp = System.currentTimeMillis();
		return "REQ" + timestamp;
	}

	/**
	 * ランダムな店舗IDを生成（例: SHOP20250105123456789）
	 * @return 生成された店舗ID
	 */
	public static String generateShopId() {
		long timestamp = System.currentTimeMillis();
		return "SHOP" + timestamp;
	}
}