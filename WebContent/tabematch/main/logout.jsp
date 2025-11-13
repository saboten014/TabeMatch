<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../../header.html" %>

<!-- 丸文字フォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
  body {
    background-color: #e8f8e8 !important;
    font-family: "Kosugi Maru", "Meiryo", sans-serif !important;
    margin: 0;
    padding: 0;
  }

  .logout-container {
    text-align: center;
    margin-top: 180px;
  }

  .logout-message {
    font-size: 40px;
    color: #333;
    margin-bottom: 30px;
  }

  .ok-button {
    font-size: 22px;
    padding: 15px 60px;
    border: 2px solid #4da6ff;
    border-radius: 10px;
    background-color: #cce5ff;
    color: #333;
    cursor: pointer;
    transition: all 0.3s ease;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
  }

  .ok-button:hover {
    background-color: #99ccff;
    border-color: #3399ff;
    transform: translateY(-3px);
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
  }
</style>

<div class="logout-container">
  <p class="logout-message">ログアウトしました。</p>
  <button class="ok-button"
    onclick="window.location.href='<%= request.getContextPath() %>/tabematch/login.jsp'">
    OK
  </button>
</div>

<%@include file="../../footer.html" %>
