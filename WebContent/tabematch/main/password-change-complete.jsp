<%@page pageEncoding="UTF-8" %>
<%!
	// ★★★ 修正箇所1: contextPathを宣言タグ（サーブレットのインスタンス変数）として定義 ★★★
    String contextPath;
%>
<%
	//★★★ 修正箇所2: スクリプトレット内でインスタンス変数に値を代入 ★★★
	contextPath = request.getContextPath();

    // ログアウトActionへのパスを想定
    String logoutPath = contextPath + "/tabematch.main/Logout.action";

    // 自動遷移までの時間（ミリ秒）
    int redirectDelay = 3000; // 3秒
%>

<%@include file="../../header.html" %>
<%@include file="/tabematch/main/user_menu.jsp" %>

    <style>
        body { font-family: sans-serif; background-color: #e8f8e8; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .complete-container {
            width: 450px;
            padding: 40px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 6px 15px rgba(0, 128, 0, 0.2);
            text-align: center;
        }
        h2 {
            color: #4CAF50;
            margin-bottom: 20px;
            font-size: 1.8em;
        }
        p {
            color: #555;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .redirect-message {
            color: #F44336; /* 赤色で注意を促す */
            font-weight: bold;
            margin-top: 20px;
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                // 3秒後にログアウトActionへ遷移
                window.location.href = "<%= logoutPath %>";
            }, <%= redirectDelay %>);
        });
    </script>
</head>
<body>

<div class="complete-container">
    <h2>✅ パスワード変更完了</h2>

    <p>
        お客様のパスワードが正常に変更されました。<br>
        セキュリティ保護のため、自動的にログアウトします。
    </p>

    <p class="redirect-message">
        3秒後に新しいパスワードで再ログイン画面へ遷移します...
    </p>

    <a href="<%= logoutPath %>">
        <button style="padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer;">
            すぐにログアウトする
        </button>
    </a>
</div>

<%@include file="../../footer.html" %>