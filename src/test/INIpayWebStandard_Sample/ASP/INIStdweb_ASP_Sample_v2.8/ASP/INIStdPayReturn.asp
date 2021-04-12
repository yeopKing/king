<% @Language="VBScript" CODEPAGE="949" %>
<%
Response.CharSet="euc-kr"
Session.codepage="949"
Response.codepage="949"
Response.ContentType="text/html;charset=euc-kr"
%>
<!--#include virtual="/include/function.asp"-->
<!--#include virtual="/include/signature.asp"-->
<!--#include virtual="/include/aspJSON1.17.asp"-->

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<style type="text/css">
		body { background-color: #efefef}
		body, tr, td {font-size:11pt font-family:굴림,verdana color:#433F37 line-height:19px}
		table, img {border:none}
		
	</style>
	<link rel="stylesheet" href="../css/group.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0>
	<div style="padding:10pxwidth:100%font-size:14pxcolor: #ffffffbackground-color: #000000text-align: center">
		이니시스 표준결제 인증결과 수신 / 승인요청, 승인결과 표시 샘플
	</div>
<% 
		'#############################
		' 인증결과 파라미터 일괄 수신
		'#############################

		Set oJSON = New aspJSON
		'#####################
		' 인증이 성공일 경우만
		'#####################
		if ("0000"=request("resultCode")) then

			response.write ("<br/><br/><br/>")
			response.write ("####인증성공/승인요청####")
			response.write ("<br/><br/><br/>")


			'############################################
			' 1.전문 필드 값 설정(***가맹점 개발수정***)
			'############################################
			
			maid 		= request("mid")							' 가맹점 ID 수신 받은 데이터로 설정
			signKey		= "SU5JTElURV9UUklQTEVERVNfS0VZU1RS"		' 가맹점에 제공된 키(웹표준 사인키) (가맹점 수정후 고정) !!!절대!! 전문 데이터로 설정금지
			correct 	= "09"										' 표준시와의 차이를 2자리 숫자로 입력 (예: 대한민국은 표준시와 9시간 차이이므로 09)
			timestamp	= time_stamp(correct)
			charset 	= "EUC-KR"									' 리턴형식[UTF-8,EUC-KR](가맹점 수정후 고정)
			format 		= "JSON"									' 리턴형식[XML,JSON,NVP](가맹점 수정후 고정)	
			
			authToken	= request("authToken")						' 취소 요청 tid에 따라서 유동적(가맹점 수정후 고정)
			authUrl		= request("authUrl")						' 승인요청 API url(수신 받은 값으로 설정, 임의 세팅 금지)
			netCancel	= request("netCancelUrl")					' 망취소 API url(수신 받은 값으로 설정, 임의 세팅 금지)
			merchantData= request("merchantData")					' 가맹점 관리데이터 수신

				
			'#####################
			' 2.signature 생성
			'#####################
			signParam = "authToken=" & replace(authToken," ", "+")	
			signParam = signParam & "&timestamp=" & timestamp
			' signature 데이터 생성 (signParam을 알파벳 순으로 hash)
			signature = MakeSignature(signParam)
			

			'#####################
			' 3.API 요청 전문 생성
			'#####################

			dim xmlHttp,  postdat
			Set xmlHttp = CreateObject("Msxml2.XMLHTTP")

			send_text = "mid="&maid
			send_text = send_text & "&timestamp="&timestamp
			send_text = send_text & "&signature="&signature
			send_text = send_text & "&authToken="&Server.URLEncode(authToken)
			send_text = send_text & "&&charset="&charset
			send_text = send_text & "&format="&format
			

			'#####################
			' 4.API 통신 시작
			'#####################

			response.write("##승인요청 API 요청##<br>")
 			xmlHttp.Open "POST", authUrl, False
 			xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; text/html; charset=euc-kr"
			xmlHttp.Send send_text
			result=Cstr( xmlHttp.responseText )

			Set oJSON = New aspJSON
			oJSON.loadJSON(result)

			'############################################################
			'5.API 통신결과 처리(***가맹점 개발수정***)
			'############################################################
			response.write ("## 승인 API 결과 ##")
			response.write("<pre>")
			response.write("<table width='565' border='0' cellspacing='0' cellpadding='0'>")	


			' signature 데이터 생성 
			authSignature = MakeSignatureAuth(maid, timestamp, oJSON.data("MOID"), oJSON.data("TotPrice"))

			if "0000"=oJSON.data("resultCode") and authSignature =oJSON.data("authSignature")  then

			    '/*****************************************************************************
			    ' * 여기에 가맹점 내부 DB에 결제 결과를 반영하는 관련 프로그램 코드를 구현한다.  
			    '
			    '   [중요!] 승인내용에 이상이 없음을 확인한 뒤 가맹점 DB에 해당건이 정상처리 되었음을 반영함
			    '            처리중 에러 발생시 망취소를 한다.
			    '******************************************************************************/

						On Error Resume Next			' 에러가 날 경우 실행

					' 이부분에 DB 기록등 내부 서비스 구현 
					' 에러 발생시 망취소
							If Err.Number > 0 Then 
							'### 망취소 통신 시작
								response.write("##망취소 요청##</br>")
								send_text = "timestamp="&timestamp
								send_text = send_text & "&mid="&maid
								send_text = send_text & "&tid="&oJSON.data("tid")
								send_text = send_text & "&authToken="&Server.URLEncode(authToken)
								send_text = send_text & "&signature="&signature
								send_text = send_text & "&SignKey="&signKey
								send_text = send_text & "&format="&format
								send_text = send_text & "&charset="&charset
								
					 			xmlHttp.Open "POST", netCancel, False
					 			xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; text/html; charset=euc-kr"
								xmlHttp.Send send_text
								ask_result=Cstr( xmlHttp.responseText )
								Set xmlHttp = nothing
									response.write "<br>" &  ask_result &"<br>"
									'################# ask_result로 반환된 전문 중  "resultCode": "0000"  이면 정상 망취소 처리.
								response.end
			  			End If   
						Err.Clear      ' Clear the error.
						On Error GoTo 0
					' 망취소여기까지
				Set xmlHttp = nothing
				
				response.write ("<tr><th class='td01'><p>거래 성공 여부</p></th>")
				response.write ("<td class='td02'><p>성공("&oJSON.data("payMethod")&")</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>결과 내용</p></th>")
				response.write("<td class='td02'><p>" &oJSON.data("resultMsg")&"</p></td></tr>")	
			else
				response.write("<tr><th class='td01'><p>거래 성공 여부</p></th>")
				response.write("<td class='td02'><p>실패("&oJSON.data("resultCode")&")</p></td></tr>")					
				if not (signature = oJSON.data("authSignature")) and "0000"=oJSON.data("resultCode") Then	' authSignature 값이 일치하지 않을 경우 패킷조작을 의심해봐야함
								
								response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
								response.write("<tr><th class='td01'><p>결과 내용</p></th>")
								response.write("<td class='td02'><p>* 데이터 위변조 체크 실패 </p></td></tr>")
								
						if "0000"=oJSON.data("resultCode")  Then		' 승인은 이루어 졌지만 authSignature이 일치 하지 않는 경우 망취소
										response.write("##망취소 요청##</br>")
										send_text = "timestamp="&timestamp
										send_text = send_text & "&mid="&maid
										send_text = send_text & "&tid="&oJSON.data("tid")
										send_text = send_text & "&authToken="&Server.URLEncode(authToken)
										send_text = send_text & "&signature="&signature
										send_text = send_text & "&SignKey="&signKey
										send_text = send_text & "&format="&format
										send_text = send_text & "&charset="&charset
										
							 			xmlHttp.Open "POST", netCancel, False
							 			xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; text/html; charset=euc-kr"
										xmlHttp.Send send_text
										ask_result=Cstr( xmlHttp.responseText )
										Set xmlHttp = nothing
											response.write "<br>" &  ask_result &"<br>"
										'################# ask_result로 반환된 전문 중  "resultCode": "0000"  이면 정상 망취소 처리.
						end if
								
								
				else
								response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
								response.write("<tr><th class='td01'><p>결과 내용</p></th>")
								response.write("<td class='td02'><p>" &oJSON.data("resultMsg")&"</p></td></tr>")	
				end if

			end if
					
			'공통 부분만
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>거래 번호</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("tid")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>결제방법(지불수단)</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("payMethod")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>결과 코드</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("resultCode")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>결제완료금액</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("TotPrice")&"원</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>주문 번호</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("MOID")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>승인날짜</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("applDate")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			response.write("<tr><th class='td01'><p>승인시간</p></th>")
			response.write("<td class='td02'><p>" &oJSON.data("applTime")&"</p></td></tr>")
			response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
			
			if "VBank"=(oJSON.data("payMethod")) then'가상계좌
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>입금 계좌번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>입금 은행코드</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_BankCode")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>입금 은행명</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("vactBankName")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>예금주 명</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_Name")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>송금자 명</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_InputName")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>송금 일자</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_Date")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>송금 시간</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("VACT_Time")&"</p></td></tr>")
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")	
				
			elseif ("DirectBank"=(oJSON.data("payMethod"))) then'실시간계좌이체
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>은행코드</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("ACCT_BankCode")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>현금영수증 발급결과코드</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CSHR_ResultCode")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>현금영수증 발급구분코드</p> <font color=red><b>(0 - 소득공제용, 1 - 지출증빙용)</b></font></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CSHR_Type")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				 
			elseif "HPP"=(oJSON.data("payMethod")) then	'휴대폰
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>통신사</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("HPP_Corp")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>결제장치</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("payDevice")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>휴대폰번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("HPP_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")

			elseif "Culture"=(oJSON.data("payMethod")) then	'문화상품권
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>문화상품권승인일자</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("applDate")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>문화상품권 승인시간</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("applTime")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>문화상품권 승인번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("applNum")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>컬처랜드 아이디</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CULT_UserID")&"</p></td></tr>")
			elseif "DGCL"=(oJSON.data("payMethod")) then	'게임문화상품권
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>게임문화상품권승인금액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GAMG_ApplPrice")&"원</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>사용한 카드수</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GAMG_Cnt")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>사용한 카드번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num1")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>카드잔액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price1")&"원</p></td></tr>")
				if(not ""=(oJSON.data("GAMG_Num2"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>사용한 카드번호</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num2")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>카드잔액</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price2")&"원</p></td></tr>")
				end if
				if(not ""=(oJSON.data("GAMG_Num3"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>사용한 카드번호</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num3")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>카드잔액</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price3")&"원</p></td></tr>")
				end if
				if(not ""=(oJSON.data("GAMG_Num4"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>사용한 카드번호</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num4")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>카드잔액</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price4")&"원</p></td></tr>")
				end if
				if(not ""=(oJSON.data("GAMG_Num5"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>사용한 카드번호</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num5")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>카드잔액</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price5")&"원</p></td></tr>")
				end if
				if(not ""=(oJSON.data("GAMG_Num6"))) then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>사용한 카드번호</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Num6")&"</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>카드잔액</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GAMG_Price6")&"원</p></td></tr>")
				end if
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "OCBPoint"=(oJSON.data("payMethod")) then'오케이 캐쉬백
			
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>지불구분</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("PayOption")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>결제완료금액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("applPrice")&"원</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>OCB 카드번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("OCB_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>적립 승인번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("OCB_SaveApplNum")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>사용 승인번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("OCB_PayApplNum")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")					
				response.write("<tr><th class='td01'><p>OCB 지불 금액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("OCB_PayPrice")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "GSPT"=(oJSON.data("payMethod")) then'GSPoint
			
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>지불구분</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("PayOption")&"</p></td></tr>")					
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>GS 포인트 승인금액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GSPT_ApplPrice")&"원</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>GS 포인트 적립금액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GSPT_SavePrice")&"원</p></td></tr>")					
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>GS 포인트 지불금액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("GSPT_PayPrice")&"원</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "UPNT"=(oJSON.data("payMethod")) then'U-포인트
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>U포인트 카드번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("UPoint_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>가용포인트</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("UPoint_usablePoint")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")			
				response.write("<tr><th class='td01'><p>포인트지불금액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("UPoint_ApplPrice")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "TEEN"=(oJSON.data("payMethod")) then'틴캐시
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>틴캐시 승인번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("TEEN_ApplNum")&"</p></td></tr>")									
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>틴캐시아이디</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("TEEN_UserID")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>틴캐시승인금액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("TEEN_ApplPrice")&"원</p></td></tr>")	
									
			elseif "Bookcash"=(oJSON.data("payMethod")) then'도서문화상품권
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>도서상품권 승인번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("BCSH_ApplNum")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>도서상품권 사용자ID</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("BCSH_UserID")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>도서상품권 승인금액</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("BCSH_ApplPrice")&"원</p></td></tr>")
				
			elseif "PhoneBill"=(oJSON.data("payMethod")) then'폰빌전화결제
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>승인전화번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("PHNB_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				
			elseif "Auth"=(oJSON.data("payMethod")) then'빌링결제
                
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>빌링키</p></th>")
					if "BILL_CARD"=(oJSON.data("payMethodDetail")) then'카드
                        response.write("<td class='td02'><p>" & oJSON.data("CARD_BillKey")& "</p></td></tr>")
                    elseif "BILL_HPP"=(oJSON.data("payMethodDetail")) then'휴대폰
						response.write("<td class='td02'><p>" & oJSON.data("HPP_BillKey")& "</p></td></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='td01'><p>통신사</p></th>")
						response.write("<td class='td02'><p>" & oJSON.data("HPP_Corp")& "</p></td></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='td01'><p>결제장치</p></th>")
						response.write("<td class='td02'><p>"  & oJSON.data("payDevice")& "</p></td></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='td01'><p>휴대폰번호</p></th>")
						response.write("<td class='td02'><p>"  & oJSON.data("HPP_Num")& "</p></td></tr>")
						response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
						response.write("<tr><th class='td01'><p>상품명</p></th>")
						response.write("<td class='td02'><p>"  & oJSON.data("goodName")& "</p></td></tr>")
					end if			
				
			else '카드
				quota = CLng(oJSON.data("CARD_Quota"))
				
				if(oJSON.data("EventCode")<>null) then				
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>이벤트 코드</p></th>")					
					response.write("<td class='td02'><p>" & oJSON.data("EventCode")&"</p></td></tr>")
				end if
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>카드번호</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_Num")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>할부기간</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_Quota")&"</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				if("1"=(oJSON.data("CARD_Interest")) or "1"=(oJSON.data("EventCode"))) then
					response.write("<tr><th class='td01'><p>할부 유형</p></th>")
					response.write("<td class='td02'><p>무이자</p></td></tr>")	
				elseif quota > 0 and  not "1"=(oJSON.data("CARD_Interest")) then
					response.write("<tr><th class='td01'><p>할부 유형</p></th>")
					response.write("<td class='td02'><p>유이자 <font color='red'> *유이자로 표시되더라도 EventCode 및 EDI에 따라 무이자 처리가 될 수 있습니다.</font></p></td></tr>")
				end If
				
				if("1"=(oJSON.data("point"))) then
					response.write("<td class='td02'><p></p></td></tr>")
					response.write("<tr><th class='td01'><p>포인트 사용 여부</p></th>")
					response.write("<td class='td02'><p>사용</p></td></tr>")
				else
					response.write("<td class='td02'><p></p></td></tr>")
					response.write("<tr><th class='td01'><p>포인트 사용 여부</p></th>")
					response.write("<td class='td02'><p>미사용</p></td></tr>")
				end if
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>카드 종류</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_Code")& "</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>카드 발급사</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_BankCode")& "</p></td></tr>")
				
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>부분취소 가능여부</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_PRTC_CODE")& "</p></td></tr>")
				response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
				response.write("<tr><th class='td01'><p>체크카드 여부</p></th>")
				response.write("<td class='td02'><p>" & oJSON.data("CARD_CheckFlag")& "</p></td></tr>")
				
				if( oJSON.data("OCB_Num")<>null and oJSON.data("OCB_Num") <> "") then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>OK CASHBAG 카드번호</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("OCB_Num")& "</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>OK CASHBAG 적립 승인번호</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("OCB_SaveApplNum")& "</p></td></tr>")
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>OK CASHBAG 포인트지불금액</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("OCB_PayPrice")& "</p></td></tr>")
				end if
				if(oJSON.data("GSPT_Num")<>null and oJSON.data("GSPT_Num") <> "") then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>GS&Point 카드번호</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GSPT_Num")& "</p></td></tr>")
					
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>GS&Point 잔여한도</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GSPT_Remains")& "</p></td></tr>")
					
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>GS&Point 승인금액</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("GSPT_ApplPrice")& "</p></td></tr>")
				end if
				
				if(oJSON.data("UNPT_CardNum")<>null and oJSON.data("UNPT_CardNum") <> "") then
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>U-Point 카드번호</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("UNPT_CardNum")& "</p></td></tr>")
					
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>U-Point 가용포인트</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("UPNT_UsablePoint")& "</p></td></tr>")
					
					response.write("<tr><th class='line' colspan='2'><p></p></th></tr>")
					response.write("<tr><th class='td01'><p>U-Point 포인트지불금액</p></th>")
					response.write("<td class='td02'><p>" & oJSON.data("UPNT_PayPrice")& "</p></td></tr>")
				'end if
				end if
			response.write("</table>")			
			response.write("</pre>")
		
			' 수신결과를 파싱후 resultCode가 "0000"이면 승인성공 이외 실패
			' 가맹점에서 스스로 파싱후 내부 DB 처리 후 화면에 결과 표시


			' payViewType을 popup으로 해서 결제를 하셨을 경우
			' 내부처리후 스크립트를 이용해 opener의 화면 전환처리를 하세요
			end if

		else 
				'#############
				' 인증 실패시
				'#############
				response.write("<br/><br/><br/>")
				response.write("####인증실패####")

				For each item in Request.Form
				    for i = 1 to Request.Form(item).Count
				    	if not(item="authToken") then
								response.write("<pre>" & item & " = " & Request.Form(item)(i) & "</pre>")
							end if
				 Next
				Next



		end if
	Set oJSON = Nothing
%>
	</body>
</html>
