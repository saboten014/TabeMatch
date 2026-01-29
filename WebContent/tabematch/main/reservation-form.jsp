<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>

<%-- CSSの読み込み --%>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation-form.css">

<div class="container">
    <h2>予約情報の入力</h2>
    <p class="shop-name-display">予約先：<strong>${shop.shopName}</strong></p>

    <%-- エラーメッセージの表示 --%>
    <c:if test="${not empty errorMessage}">
        <p class="error-message">${errorMessage}</p>
    </c:if>

    <form action="ReserveExecute.action" method="post" class="reserve-form">
        <%-- 店舗IDを隠しフィールドで送信 --%>
        <input type="hidden" name="shopId" value="${shop.shopId}">

        <%-- 基本予約情報 --%>
        <div class="form-group">
            <label for="visitDate">来店日</label>
            <input type="date" name="visitDate" id="visitDate" required>
        </div>

        <div class="form-group">
            <label for="visitTime">来店時間</label>
            <input type="time" name="visitTime" id="visitTime" required>
        </div>

        <div class="form-group">
            <label for="numOfPeople">人数</label>
            <input type="number" name="numOfPeople" id="numOfPeople" min="1" value="1" required>
        </div>

        <div class="form-item">
		    <label>連絡先電話番号 <span style="color:red;">(必須)</span></label>
		    <input type="tel" name="reserve_tel" required
		           placeholder="09012345678"
		           pattern="\d{10,11}"
		           title="ハイフンなしで10桁または11桁の数字を入力してください"
		           style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ddd;">
		    <p style="font-size: 0.8rem; color: #666;">※当日お店から連絡する場合があります。</p>
		</div>

        <hr>

        <%-- アレルギー選択エリア（動的生成） --%>
        <div class="form-group">
            <label>アレルギーをお持ちの食材（お店の対応状況）</label>
            <p class="sub-label">※お店側で対応可能としている項目のみ選択できます。その他は「詳細」にご記入ください。</p>

            <div class="allergy-options">
                <%-- 全アレルゲンマスターをループ --%>
                <c:forEach var="a" items="${allAllergens}">
                    <c:set var="isAvailable" value="false" />

                    <%-- お店の対応リスト（名前リスト）に含まれているか判定 --%>
                    <c:forEach var="shopOkName" items="${shopAllergenNames}">
                        <c:if test="${a.allergenName == shopOkName}">
                            <c:set var="isAvailable" value="true" />
                        </c:if>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${isAvailable}">
                            <%-- 対応可：緑色のラベル --%>
                            <label class="allergy-item available">
                                <input type="checkbox" name="allergy" value="${a.allergenName}">
                                <span class="allergen-name">${a.allergenName}</span>
                            </label>
                        </c:when>
                        <c:otherwise>
                            <%-- 対応不可：グレーアウト＆無効化 --%>
                            <label class="allergy-item unavailable">
                                <input type="checkbox" name="allergy" value="${a.allergenName}" disabled>
                                <span class="allergen-name">${a.allergenName}</span>
                            </label>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>

            <label for="allergyNotes" class="mt-10">アレルギーに関する詳細</label>
            <textarea name="allergyNotes" id="allergyNotes" rows="3"
                placeholder="例：つなぎの卵もNG、重度の症状がある、など"></textarea>
        </div>

        <%-- お店へのメッセージ --%>
        <div class="form-group">
            <label for="message">お店へのメッセージ（任意）</label>
            <textarea name="message" id="message" rows="3"></textarea>
        </div>

        <%-- ボタンエリア --%>
        <div class="button-group">
            <button type="submit" class="btn-submit">予約を確定する</button>
            <a href="search.jsp" class="btn-back">戻る</a>
        </div>
    </form>
</div>


<script>
    // 現在の日時を取得
    const now = new Date();

    // 日付フィールドの最小値を今日に設定
    const dateInput = document.getElementById('visitDate');
    const today = now.toISOString().split('T')[0];
    dateInput.setAttribute('min', today);

    // 時間フィールドの制御
    const timeInput = document.getElementById('visitTime');

    // 2時間後の時刻を計算
    const twoHoursLater = new Date(now.getTime() + 2 * 60 * 60 * 1000);
    const hours = String(twoHoursLater.getHours()).padStart(2, '0');
    const minutes = String(twoHoursLater.getMinutes()).padStart(2, '0');
    const minTime = hours + ':' + minutes;

    // 日付が変更されたときと、ページ読み込み時に時間制限をチェック
    function updateTimeRestriction() {
        const selectedDate = dateInput.value;

        if (selectedDate === today) {
            // 今日が選択された場合、2時間後以降のみ選択可能
            timeInput.setAttribute('min', minTime);

            // 既に入力されている時間が制限より前なら、クリア
            if (timeInput.value && timeInput.value < minTime) {
                timeInput.value = '';
            }
        } else {
            // 今日以外の日付が選択された場合、時間制限なし
            timeInput.removeAttribute('min');
        }
    }

    // 時間が入力されたときにもチェック
    function validateTime() {
        const selectedDate = dateInput.value;
        const selectedTime = timeInput.value;

        if (selectedDate === today && selectedTime && selectedTime < minTime) {
            alert('予約時間は2時間後（' + minTime + '）以降を選択してください。');
            timeInput.value = '';
        }
    }

    // イベントリスナーを設定
    dateInput.addEventListener('change', updateTimeRestriction);
    timeInput.addEventListener('change', validateTime);
    timeInput.addEventListener('blur', validateTime);

    // ページ読み込み時に初期チェックを実行
    updateTimeRestriction();

    // フォーム送信時のバリデーション
    document.querySelector('.reserve-form').addEventListener('submit', function(e) {
        const selectedDate = dateInput.value;
        const selectedTime = timeInput.value;

        if (selectedDate === today && selectedTime) {
            const selectedDateTime = new Date(selectedDate + 'T' + selectedTime);

            if (selectedDateTime < twoHoursLater) {
                e.preventDefault();
                alert('予約時間は2時間後（' + minTime + '）以降を選択してください。');
                return false;
            }
        }
    });
</script>

<%@ include file="../../footer.html" %>