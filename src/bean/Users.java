package bean;

public class Users {
	private String userId;
	private String password;
	private String userName;
	private String allergenId;
	private String usersTypeId;

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
}