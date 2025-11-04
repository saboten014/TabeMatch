package bean;

public class UserType {
	private String usersTypeId;
	private String usersType;

	// コンストラクタ
	public UserType() {
	}

	// Getter and Setter
	public String getUsersTypeId() {
		return usersTypeId;
	}

	public void setUsersTypeId(String usersTypeId) {
		this.usersTypeId = usersTypeId;
	}

	public String getUsersType() {
		return usersType;
	}

	public void setUsersType(String usersType) {
		this.usersType = usersType;
	}
}