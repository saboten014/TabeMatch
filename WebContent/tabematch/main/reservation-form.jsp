<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation-form.css">

<%-- 注意喚起用の追加スタイル --%>
<style>
    .shop-info-box {
        background-color: #f0f7f0;
        border: 1px solid #4CAF50;
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 20px;
    }
    .shop-info-title {
        font-weight: bold;
        color: #2e7d32;
        margin-bottom: 5px;
        font-size: 0.95em;
    }
    .shop-info-content {
        font-size: 1.1em;
        color: #333;
        margin-bottom: 10px;
    }
    .caution-box {
        background-color: #fff9c4;
        border-left: 4px solid #fbc02d;
        padding: 10px 15px;
        font-size: 0.85em;
        color: #5d4037;
    }
</style>

<div class="container">
    <h2>予約情報の入力</h2>
    <p class="shop-name-display">予約先：<strong>${shop.shopName}</strong></p>

    <%-- 店舗の営業時間・定休日を表示 --%>
    <div class="shop-info-box">
        <div class="shop-info-title">📅 店舗の営業時間・定休日</div>
        <div class="shop-info-content">
            <c:out value="${not empty shop.shopTime ? shop.shopTime : '店舗へ直接ご確認ください'}" />
        </div>
        <div class="caution-box">
            ⚠️ <strong>ご注意：</strong><br>
            休業日に予約を入れた場合、店舗都合により予約がキャンセルされる可能性があります。上記の日程をよくご確認の上、入力をお願いします☘️
        </div>
    </div>

    <%-- エラーメッセージの表示 --%>
    <c:if test="${not empty errorMessage}">
        <p class="error-message">${errorMessage}</p>
    </c:if>

    <form action="ReserveExecute.action" method="post" class="reserve-form">
        <input type="hidden" name="shopId" value="${shop.shopId}">

        <%-- 基本予約情報 --%>
        <div class="form-group">
            <label for="visitDate">来店日<span style="color:red;">*</span></label>
            <input type="date" name="visitDate" id="visitDate" required>
        </div>

        <div class="form-group">
            <label for="visitTime">来店時間<span style="color:red;">*</span></label>
            <input type="time" name="visitTime" id="visitTime" required>
        </div>

        <div class="form-group">
            <label for="numOfPeople">人数<span style="color:red;">*</span></label>
            <input type="number" name="numOfPeople" id="numOfPeople" min="1" max="10" value="1" required>
            <p style="font-size: 0.8rem; color: #666; margin-top: 5px;">※11名以上の予約は直接店舗へお電話でご確認ください。</p>
        </div>

        <div class="form-item">
            <label>連絡先電話番号 <span style="color:red;">*</span></label>
            <input type="tel" name="reserve_tel" id="reserve_tel" required
                   placeholder="09012345678"
                   maxlength="13"
                   style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ddd; box-sizing: border-box;">
            <div id="tel-error" style="color: red; font-size: 0.8rem; display: none; margin-top: 5px;">
                ※電話番号は10桁または11桁で入力してください
            </div>
        </div>

        <hr>

        <%-- アレルギー選択エリア --%>
        <div class="form-group">
            <label>配慮が必要な食材（お店の対応状況）</label>
            <p class="sub-label">※お店側で対応可能としている項目のみ選択できます。その他は「詳細」にご記入ください。</p>

            <div class="allergy-options">
                <c:forEach var="a" items="${allAllergens}">
                    <c:set var="isAvailable" value="false" />
                    <c:forEach var="shopOkName" items="${shopAllergenNames}">
                        <c:if test="${a.allergenName == shopOkName}">
                            <c:set var="isAvailable" value="true" />
                        </c:if>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${isAvailable}">
                            <label class="allergy-item available">
                                <input type="checkbox" name="allergy" value="${a.allergenName}">
                                <span class="allergen-name">${a.allergenName}</span>
                            </label>
                        </c:when>
                        <c:otherwise>
                            <label class="allergy-item unavailable">
                                <input type="checkbox" name="allergy" value="${a.allergenName}" disabled>
                                <span class="allergen-name">${a.allergenName}</span>
                            </label>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>

            <label for="allergyNotes" class="mt-10">食材の配慮に関する詳細（任意）</label>
            <textarea name="allergyNotes" id="allergyNotes" rows="3"
                placeholder="例：つなぎの卵もNG、重度の症状がある、宗教上の理由で食べられない、など"></textarea>
        </div>

        <div class="form-group">
            <label for="message">お店へのメッセージ（任意）</label>
            <textarea name="message" id="message" rows="3"></textarea>
        </div>

        <div class="button-group">
            <button type="submit" class="btn-submit">予約を確定する</button>
            <a href="search.jsp" class="btn-back">戻る</a>
        </div>
    </form>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    // --- 1. 日付・時間の制御 ---
    const now = new Date();
    const dateInput = document.getElementById('visitDate');
    const today = now.toISOString().split('T')[0];
    dateInput.setAttribute('min', today);

    const timeInput = document.getElementById('visitTime');
    const twoHoursLater = new Date(now.getTime() + 2 * 60 * 60 * 1000);
    const hours = String(twoHoursLater.getHours()).padStart(2, '0');
    const minutes = String(twoHoursLater.getMinutes()).padStart(2, '0');
    const minTime = hours + ':' + minutes;

    function updateTimeRestriction() {
        if (dateInput.value === today) {
            timeInput.setAttribute('min', minTime);
            if (timeInput.value && timeInput.value < minTime) {
                timeInput.value = '';
            }
        } else {
            timeInput.removeAttribute('min');
        }
    }

    function validateTime() {
        if (dateInput.value === today && timeInput.value && timeInput.value < minTime) {
            alert('予約時間は2時間後（' + minTime + '）以降を選択してください。');
            timeInput.value = '';
        }
    }

    dateInput.addEventListener('change', updateTimeRestriction);
    timeInput.addEventListener('change', validateTime);
    updateTimeRestriction();

    // --- 2. 人数制限 ---
    const numInput = document.getElementById('numOfPeople');
    function validateNumOfPeople() {
        const val = parseInt(numInput.value);
        if (val > 10) {
            alert('WEBからの予約は10名様までとなります。\n11名以上の場合は、直接店舗へお電話にてお問い合わせください。');
            numInput.value = 10;
        }
    }
    numInput.addEventListener('change', validateNumOfPeople);
    numInput.addEventListener('input', validateNumOfPeople);

    // --- 3. 電話番号の自動整形 ---
    const telInput = document.getElementById("reserve_tel");
    const telError = document.getElementById("tel-error");

    if (telInput) {
        telInput.addEventListener("input", () => {
            let value = telInput.value.replace(/\D/g, "");
            let formatted = "";
            const len = value.length;

            if (len <= 3) {
                formatted = value;
            } else if (len <= 6) {
                formatted = value.substring(0, 3) + "-" + value.substring(3);
            } else if (len <= 10) {
                if (value.startsWith("03") || value.startsWith("06")) {
                    formatted = value.substring(0, 2) + "-" + value.substring(2, 6) + "-" + value.substring(6);
                } else {
                    formatted = value.substring(0, 3) + "-" + value.substring(3, 6) + "-" + value.substring(6);
                }
            } else {
                formatted = value.substring(0, 3) + "-" + value.substring(3, 7) + "-" + value.substring(7, 11);
            }
            telInput.value = formatted;

            if (len > 0 && len !== 10 && len !== 11) {
                telError.style.display = "block";
                telInput.style.borderColor = "red";
            } else {
                telError.style.display = "none";
                telInput.style.borderColor = (len === 0) ? "#ddd" : "#4CAF50";
            }
        });
    }

    // --- 4. 送信時の最終チェック ---
    document.querySelector('.reserve-form').addEventListener('submit', function(e) {
        if (dateInput.value === today && timeInput.value) {
            const selectedDateTime = new Date(dateInput.value + 'T' + timeInput.value);
            if (selectedDateTime < twoHoursLater) {
                e.preventDefault();
                alert('予約時間は2時間後（' + minTime + '）以降を選択してください。');
                return;
            }
        }
        const telLen = telInput.value.replace(/\D/g, "").length;
        if (telLen > 0 && telLen !== 10 && telLen !== 11) {
            e.preventDefault();
            alert("電話番号を10桁または11桁で正しく入力してください。");
            return;
        }
    });
});
</script>

<%@ include file="../../footer.html" %>