package bean;

public class ShopUser {
    private int shopUserId;
    private int shopId;
    private String email;
    private String password;

    public ShopUser() {}

    public ShopUser(int shopUserId, int shopId, String email, String password) {
        this.shopUserId = shopUserId;
        this.shopId = shopId;
        this.email = email;
        this.password = password;
    }

    public int getRestaurantUserId() { return shopUserId; }
    public void setRestaurantUserId(int restaurantUserId) { this.shopUserId = restaurantUserId; }

    public int getRestaurantId() { return shopId; }
    public void setRestaurantId(int restaurantId) { this.shopId = restaurantId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
