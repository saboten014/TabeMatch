package bean;

import java.time.LocalDateTime;

public class Review {

    private String reviewId;
    private String userId;
    private String shopId;
    private String title;
    private String body;
    private int rating;
    private LocalDateTime createdAt;

    // ---- getter/setter ----

    public String getReviewIdString() { return reviewId; }
    public void setReviewIdString(String reviewId) { this.reviewId = reviewId; }

    public String getUserIdString() { return userId; }
    public void setUserIdString(String userId) { this.userId = userId; }

    public String getShopIdString() { return shopId; }
    public void setShopIdString(String shopId) { this.shopId = shopId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getBody() { return body; }
    public void setBody(String body) { this.body = body; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
