package bean;

import java.sql.Date;
import java.sql.Time;

public class Reserve {
    private int reserveId;           // int型のID（後方互換性のため残す）
    private String reserveIdString;  // UUID用の文字列ID（新規追加）
    private String userId;
    private String shopId;
    private Date visitDate;
    private Time visitTime;
    private int numOfPeople;
    private String allergyNotes;
    private String message;
    private String status;
    private String shopName;
    private int reserveStatus; // 1=未承認, 2=承認, 3=拒否

    public Reserve() {}

    public int getReserveId() { return reserveId; }
    public void setReserveId(int reserveId) { this.reserveId = reserveId; }

    // UUID用のGetter/Setter（新規追加）
    public String getReserveIdString() { return reserveIdString; }
    public void setReserveIdString(String reserveIdString) {
        this.reserveIdString = reserveIdString;
        // int型のIDも設定（後方互換性のため）
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
}