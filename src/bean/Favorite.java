package bean;

public class Favorite {

	private String favUserId;
	private String favShopId;
	private java.sql.Timestamp createdAt;


	public String getFavUserId() {
		return favUserId;
	}
	public void setFavUserId(String favUserId) {
		this.favUserId = favUserId;
	}

	public String getFavShopId() {
		return favShopId;
	}
	public void setFavShopId(String favShopId) {
		this.favShopId = favShopId;
	}

	public java.sql.Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(java.sql.Timestamp createdAt) {
		this.createdAt = createdAt;
	}



}
