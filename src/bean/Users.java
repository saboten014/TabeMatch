package bean;

import java.sql.Timestamp;  // ★追加：created_at 取得用

public class Users {
	private String userId;
	private String password;
	private String userName;
	private String allergenId;
	private String usersTypeId;

	// ★追加：登録日（created_at）
	private Timestamp createdAt;

	// コンストラクタ
	public Users() {
	}

	// Getter and Setter
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getAllergenId() {
		return allergenId;
	}

	public void setAllergenId(String allergenId) {
		this.allergenId = allergenId;
	}

	public String getUsersTypeId() {
		return usersTypeId;
	}

	public void setUsersTypeId(String usersTypeId) {
		this.usersTypeId = usersTypeId;
	}

	// ★追加：created_at Getter/Setter
	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
}