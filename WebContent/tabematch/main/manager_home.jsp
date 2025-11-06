<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>管理者ホーム | たべまっち</title>

<style>
  body {
    font-family: "Meiryo", sans-serif;
    background-color: #d7f8d3; /* 全体の淡い緑 */
    margin: 0;
    padding: 0;
  }

  /* 外枠 */
  .container {
    width: 80%;
    margin: 40px auto;
    background-color: #c6f0c1;
    border: 2px solid #57a360;
    border-radius: 8px;
    box-shadow: 0 0 3px rgba(0,0,0,0.2);
  }

  /* ヘッダー */
  .header {
    background-color: #7bc97b;
    padding: 15px 25px;
    border-top-left-radius: 8px;
    border-top-right-radius: 8px;
  }

  .header h1 {
    color: #ff8c00; /* オレンジ文字 */
    margin: 0;
    font-size: 28px;
  }

  /* ボタン配置部分 */
  .content {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 30px;
    padding: 40px 0;
  }

  /* 各ボタン（カード） */
  .card {
    background-color: #fff;
    width: 180px;
    height: 100px;
    border: 1px solid #666;
    border-radius: 6px;
    box-shadow: 1px 2px 3px rgba(0,0,0,0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 500;
    text-align: center;
    text-decoration: none;
    color: #000;
    transition: 0.2s;
  }

  .card:hover {
    background-color: #f0fff0;
    transform: translateY(-3px);
  }
</style>
</head>

<body>
  <div class="container">
    <div class="header">
      <h1>たべまっち</h1>
    </div>

    <div class="content">
      <a href="" class="card">ユーザーの管理</a>
      <a href="" class="card">掲載リクエスト承認</a>
      <a href="" class="card">管理者アカウント追加</a>
      <a href="" class="card">店舗の管理</a>
      <a href="" class="card">お知らせ配信</a>
    </div>
  </div>
</body>
</html>
