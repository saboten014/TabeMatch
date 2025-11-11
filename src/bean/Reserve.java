package bean;

public class Reserve {
    private int reserveId;
    private int userId;
    private int restaurantId;
    private int numOfPeople;
    private String status;

    public Reserve() {}

    public Reserve(int reserveId, int userId, int restaurantId,  int numOfPeople, String status) {
        this.reserveId = reserveId;
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.numOfPeople = numOfPeople;
        this.status = status;
    }

    public int getReserveId() { return reserveId; }
    public void setReserveId(int reserveId) { this.reserveId = reserveId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public int getNumOfPeople() { return numOfPeople; }
    public void setNumOfPeople(int numOfPeople) { this.numOfPeople = numOfPeople; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
