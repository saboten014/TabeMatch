package bean;

import java.sql.Date;
import java.sql.Time;

public class Reserve {
    private int reserveId;
    private String userId;
    private String shopId;
    private Date visitDate;
    private Time visitTime;
    private int numOfPeople;
    private String allergyNotes;
    private String message;
    private String status;
    private String shopName;

    public Reserve() {}

    public int getReserveId() { return reserveId; }
    public void setReserveId(int reserveId) { this.reserveId = reserveId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getShopId() { return shopId; }
    public void setShopId(String shopId) { this.shopId = shopId; }

    public Date getVisitDate() { return visitDate; }
    public void setVisitDate(Date visitDate) { this.visitDate = visitDate; }

    public Time getVisitTime() { return visitTime; }
    public void setVisitTime(Time visitTime) { this.visitTime = visitTime; }

    public int getNumOfPeople() { return numOfPeople; }
    public void setNumOfPeople(int numOfPeople) { this.numOfPeople = numOfPeople; }

    public String getAllergyNotes() { return allergyNotes; }
    public void setAllergyNotes(String allergyNotes) { this.allergyNotes = allergyNotes; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getShopName() { return shopName; }
    public void setShopName(String shopName) { this.shopName = shopName; }
}
