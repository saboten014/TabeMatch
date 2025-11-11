package bean;
import java.sql.Timestamp;

public class News {
	private String newsId;
	private String newsTitle;
	private String newsText;
	private Timestamp deliveryDate;
	private Timestamp editDate;
	private String role;


	public String getNewsId() {
		return newsId;
	}
	public void setNewsId(String newsId) {
		this.newsId = newsId;
	}


	public String getNewsTitle() {
		return newsTitle;
	}
	public void setNewsTitle(String newsTitle) {
		this.newsTitle = newsTitle;
	}


	public String getNewsText() {
		return newsText;
	}
	public void setNewsText(String newsText) {
		this.newsText = newsText;
	}


	public Timestamp getDeliveryDate() {
		return deliveryDate;
	}
	public void setDeliveryDate(Timestamp deliveryDate) {
		this.deliveryDate = deliveryDate;
	}


	public Timestamp getEditDate() {
		return editDate;
	}
	public void setEditDate(Timestamp editDate) {
		this.editDate = editDate;
	}


	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}

}
