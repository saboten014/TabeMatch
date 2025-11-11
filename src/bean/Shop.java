package bean;

import java.sql.Time;
import java.sql.Timestamp;

public class Shop {
	private String shopId;
	private String password;
	private String shopAddress;
	private String shopName;
	private String shopAllergy;
	private String shopMail;
	private String shopTel;
	private Timestamp shopDate;
	private Time shopTime;
	private String shopReserve;
	private String shopGenre;
	private String shopPicture;
	private String shopPrice;
	private String shopPay;
	private Integer shopSeat;
	private String shopUrl;
	private String reviewId;

	// コンストラクタ
	public Shop() {
	}

	// Getter and Setter
	public String getShopId() {
		return shopId;
	}

	public void setShopId(String shopId) {
		this.shopId = shopId;
	}

	public String getPassword() {
	    return password;
	}

	public void setPassword(String password) {
	    this.password = password;
	}


	public String getShopAddress() {
		return shopAddress;
	}

	public void setShopAddress(String shopAddress) {
		this.shopAddress = shopAddress;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public String getShopAllergy() {
		return shopAllergy;
	}

	public void setShopAllergy(String shopAllergy) {
		this.shopAllergy = shopAllergy;
	}

	public String getShopMail() {
		return shopMail;
	}

	public void setShopMail(String shopMail) {
		this.shopMail = shopMail;
	}

	public String getShopTel() {
		return shopTel;
	}

	public void setShopTel(String shopTel) {
		this.shopTel = shopTel;
	}

	public Timestamp getShopDate() {
		return shopDate;
	}

	public void setShopDate(Timestamp shopDate) {
		this.shopDate = shopDate;
	}

	public Time getShopTime() {
		return shopTime;
	}

	public void setShopTime(Time shopTime) {
		this.shopTime = shopTime;
	}

	public String getShopReserve() {
		return shopReserve;
	}

	public void setShopReserve(String shopReserve) {
		this.shopReserve = shopReserve;
	}

	public String getShopGenre() {
		return shopGenre;
	}

	public void setShopGenre(String shopGenre) {
		this.shopGenre = shopGenre;
	}

	public String getShopPicture() {
		return shopPicture;
	}

	public void setShopPicture(String shopPicture) {
		this.shopPicture = shopPicture;
	}

	public String getShopPrice() {
		return shopPrice;
	}

	public void setShopPrice(String shopPrice) {
		this.shopPrice = shopPrice;
	}

	public String getShopPay() {
		return shopPay;
	}

	public void setShopPay(String shopPay) {
		this.shopPay = shopPay;
	}

	public Integer getShopSeat() {
		return shopSeat;
	}

	public void setShopSeat(Integer shopSeat) {
		this.shopSeat = shopSeat;
	}

	public String getShopUrl() {
		return shopUrl;
	}

	public void setShopUrl(String shopUrl) {
		this.shopUrl = shopUrl;
	}

	public String getReviewId() {
		return reviewId;
	}

	public void setReviewId(String reviewId) {
		this.reviewId = reviewId;
	}
}