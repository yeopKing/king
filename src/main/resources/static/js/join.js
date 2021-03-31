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
    if($("#email").val() != "")
        var regExp = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/; //메일 정규식
    var checkEmail = $("#email").val();

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
        url:"../user/join/do",
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


        },
        dataType:"json",
        success:function (data) {
            if(data.resultCode === 0){
                alert("사용자등록을 완료했습니다.");
                toPage("../user/inquiry.html");
            }else if(data.resultCode === 1){
                alert(data.description);
            }else if(data.resultCode === 2){
                alert(data.description);
            }else if(data.resultCode === 9){
                alert(data.description);
            }else if(data.resultCode === 4){
                alert(data.description);
                regError("#userJoinSearchBody", "join_"+data.tagId);
            }else if(data.resultCode === 3){
                alert(data.description);
            }else{
                alert(unknownErrorMessage);
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
