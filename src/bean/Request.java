package bean;

public class Request {
	private String requestId;
	private String address;
	private String restaurantName;
	private String allergySupport;
	private Integer reservation;
	private String businessHours;
	private String payment;
	private String genre;
	private String photo;
	private String priceRange;
	private String seat;
	private String link;
	private String phone_number;
	private Integer certification;
	private String request_mail;

	// コンストラクタ
	public Request() {
	}

	// Getter and Setter
	public String getRequestId() {
		return requestId;
	}

	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getRestaurantName() {
		return restaurantName;
	}

	public void setRestaurantName(String restaurantName) {
		this.restaurantName = restaurantName;
	}

	public String getAllergySupport() {
		return allergySupport;
	}

	public void setAllergySupport(String allergySupport) {
		this.allergySupport = allergySupport;
	}

	public Integer getReservation() {
		return reservation;
	}

	public void setReservation(Integer reservation) {
		this.reservation = reservation;
	}

	public String getBusinessHours() {
		return businessHours;
	}

	public void setBusinessHours(String businessHours) {
		this.businessHours = businessHours;
	}

	public String getPayment() {
		return payment;
	}

	public void setPayment(String payment) {
		this.payment = payment;
	}

	public String getGenre() {
		return genre;
	}

	public void setGenre(String genre) {
		this.genre = genre;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public String getPriceRange() {
		return priceRange;
	}

	public void setPriceRange(String priceRange) {
		this.priceRange = priceRange;
	}

	public String getSeat() {
		return seat;
	}

	public void setSeat(String seat) {
		this.seat = seat;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public String getNumber() {
		return phone_number;
	}

	public void setNumber(String number) {
		this.phone_number = number;
	}

	public Integer getCertification() {
		return certification;
	}

	public void setCertification(Integer certification) {
		this.certification = certification;
	}

	public String getEmail(){
		return request_mail;
	}

	public void setEmail(String email){
		this.request_mail = email;
	}

	public String getRequest_mail() {
		return request_mail;
	}

	public void setRequest_mail(String request_mail) {
		this.request_mail = request_mail;
	}
}