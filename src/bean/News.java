package bean;

public class News {
    private int newsId;
    private String title;
    private String content;
    private String author;

    public News() {}

    public News(int newsId, String title, String content, String author) {
        this.newsId = newsId;
        this.title = title;
        this.content = content;
        this.author = author;
    }

    public int getNewsId() { return newsId; }
    public void setNewsId(int newsId) { this.newsId = newsId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
}
