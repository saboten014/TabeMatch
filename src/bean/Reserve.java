package bean;

import java.sql.Date;
import java.sql.Time;

public class Reserve {
    private int reserveId;
    private String reserveIdString;
    private String userId;
    private String shopId;
    private Date visitDate;
    private Time visitTime;
    private int numOfPeople;
    private String allergyNotes;
    private String message;
    private String status;
    private String shopName;
    private int reserveStatus;
    private String userName;
    private String reserveTel;

    public Reserve() {}

    // --- 既存のメソッドはそのまま ---

    // ★追加：電話番号のGetter/Setter
    public String getReserveTel() { return reserveTel; }
    public void setReserveTel(String reserveTel) { this.reserveTel = reserveTel; }

    // --- 以下、既存のGetter/Setter（省略） ---
    public int getReserveId() { return reserveId; }
    public void setReserveId(int reserveId) { this.reserveId = reserveId; }
    public String getReserveIdString() { return reserveIdString; }
    public void setReserveIdString(String reserveIdString) {
        this.reserveIdString = reserveIdString;
        if (reserveIdString != null) {
            this.reserveId = reserveIdString.hashCode();
        }
    }
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
    public int getReserveStatus() { return reserveStatus; }
    public void setReserveStatus(int reserveStatus) { this.reserveStatus = reserveStatus; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}