/**
 * 회원가입 실행
 */
function doJoin() {
    var flag = false;
    $("#userJoinSearchBody").find("input").each(function () { // input 빈칸 체크
        if ($(this).attr("required") && $(this).val().trim().length < 1) {
            $(this).focus();
            flag = true;
            alert("빈칸없이 작성해주세요.");
            return false;
        }
    });
    if($("#joinEmail").val() != "")
        var regExp = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/; //메일 정규식
    var checkEmail = $("#joinEmail").val();

    if(regExp.test(checkEmail) == true){

    }else {
        alert("이메일 주소 형식이 맞지 않습니다!")
        return false;
    }

    var arr = []; //Object를 배열로 저장할 Array

    if ($("#joinPasswordForm").val() !== $("#joinPasswordConfirmForm").val()) {
        alert("비밀번호가 같지 않습니다. 다시 확인해주세요.");
        $("#joinPasswordConfirmForm").val('');
        $("#joinPasswordConfirmForm").focus;
        return;
    }

    $.ajax({
        url:"../join/do",
        method:"POST",
        data:{
            "accountId":$("#joinIdForm").val(), //사용자 아이디
            "password":$("#joinPasswordForm").val(), //비밀번호
            "name":$("#joinNameForm").val(), //이름
            "tel1":$("#joinTel1Form").val(), //전화번호1
            "tel2":$("#joinTel2Form").val(),//전화번호2

            "zipcode":$("#joinZipcodeForm").val(),//우편번호
            "address":$("#joinAddressForm").val(),//주소
            "detailAddress":$("#joinDetailAddressForm").val(),//상세주소
            "email":$("#joinEmail").val()//이메일
        },
        dataType:"json",
        success:function (data) {
            if(data.result === 0){
                alert("사용자등록을 완료했습니다.");
                window.location.href="../index";
            }else if(data.result === 777){
                alert("에러발생");
            }else{
                alert("알 수 없는 에러입니다. 문의해주세요");Í
            }
        },
        error:function (xhr,status,err) {
            alert(status+"\n"+err)
        }
    });
}

// /**
//  * 배송지 우편번호 검색
//  */
// $("#joinZipcodeForm").click(function () {
//     new daum.Postcode({
//         oncomplete:function (data) {
//             $("#joinZipcodeForm").val(data.zonecode);
//             $("#joinAddressForm").val(data.address);
//             $("#joinDetailAddressForm").val('');
//         }
//     }).open();
// });
