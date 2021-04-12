<%@ Page Language="C#" AutoEventWireup="true" CodeFile="INIStdPayBill.aspx.cs" Inherits="INIStdPayBill" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>INIStd 웹표준결제</title>

    <style type="text/css">
        body { background-color: #efefef;}
        body, tr, td {font-size:9pt; font-family:굴림,verdana; color:#433F37; line-height:19px;}
        table, img {border:none}
    </style>

    <!-- 이니시스 표준결제 js -->
    <script type="text/javascript" src="https://stgstdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>

    <script type="text/javascript">
        function send() 
        {    
            INIStdPay.pay('SendPayForm_id');
        }

        function Radio_Click() {
            var val = "";
            var radio = document.getElementsByName("payTypeChk");
            if (radio.length > 0) {
                if (radio[0].checked) {
                    document.getElementById("acceptmethod").value = "BILLAUTH(card):FULLVERIFY";
                } else {
                    document.getElementById("acceptmethod").value = "BILLAUTH(HPP):HPP(1)";
                }
            }
        }

    </script>
</head>
<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0>
	
	<div style="padding:10px;background-color:#f3f3f3;width:100%;font-size:13px;color: #ffffff;background-color: #000000;text-align: center">
		이니시스 표준결제 신용카드 빌링키 발급 샘플
	</div>
	
	<table width="650" border="0" cellspacing="0" cellpadding="0" style="padding:10px;" align="center">
		<tr>
			<td bgcolor="6095BC" align="center" style="padding:10px">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" style="padding:20px">                        <tr>
                            <td>
                                이 페이지는 INIpay Standard 결제요청을 위한 예시입니다.<br/>
                                <br/>
                                결제처리를 위한 action등의 모든 동작은 Import 된 스크립트에 의해 자동처리됩니다.
                                <br/><br/>
							    Form에 설정된 모든 필드의 name은 대소문자 구분하며,<br/>
							    이 Sample은 결제를 위해서 설정된 Form은 테스트 / 이해돕기를 위해서 모두 type="text"로 설정되어 있습니다.<br/>
							    운영에 적용시에는 일부 가맹점에서 필요에 의해 사용자가 변경하는 경우를 제외하고<br/>
							    모두 type="hidden"으로 변경하여 사용하시기 바랍니다.<br/>
                                <br/>
                                <strong style="color: #336699;">함께 제공되는 매뉴얼을 참조하여 작성 개발하시기 바랍니다.</strong>
                                <br/><br/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td style="text-align:left;">
                                            <form id="SendPayForm_id" method="post"    runat="server">   
                                                           
                                                <asp:RadioButtonList ID="payTypeChk" runat="server" RepeatDirection="Horizontal" OnClick="return Radio_Click()">
                                                    <asp:ListItem value="card" Selected="True">카드빌링</asp:ListItem>
                                                    <asp:ListItem value="hpp">휴대폰빌링</asp:ListItem>
                                                </asp:RadioButtonList>                                                   
                                                <asp:Button id="Button1" runat="server" Text="결제요청" OnClientClick="send(); return false" style="padding:10px"></asp:Button>
                                                <br/>
                                                <!-- 필수 -->
                                                <br/><b>***** 필 수 *****</b>
                                                <div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;text-align:left">

                                                    <br/><b>version</b> :
                                                    <br/><asp:textbox    id="version" Text="" runat="server" Width="400px" />

                                                    <br/><b>mid</b> :
                                                    <br/><asp:textbox    id="mid" Text="" runat="server" Width="400px" />

                                                    <br/><b>goodname</b> :
                                                    <br/><asp:textbox   id="goodname" Text="" runat="server" Width="400px" />

                                                    <br/><b>oid</b> :
                                                    <br/><asp:textbox   id="oid" Text="" runat="server" Width="400px" />

                                                    <br/><b>price</b> :
                                                    <br/><asp:textbox   id="price" Text="" runat="server" Width="400px" />

                                                    <br/><b>currency</b> :
                                                    <br/>[WON|USD]
                                                    <br/><asp:textbox   id="currency" Text="" runat="server" Width="400px" />

                                                    <br/><b>buyername</b> :
                                                    <br/><asp:textbox   id="buyername" Text="" runat="server" Width="400px" />

                                                    <br/><b>buyertel</b> :
                                                    <br/><asp:textbox   id="buyertel" Text="" runat="server" Width="400px" />

                                                    <br/><b>buyeremail</b> :
                                                    <br/><asp:textbox   id="buyeremail" Text="" runat="server" Width="400px" />
                                                    <br/>
                                                    <br/><b>returnUrl</b> : 
                                                    <br/><asp:textbox   id="returnUrl" Text="" runat="server" Width="400px"/>
                                                    <br/>
                                                    <br/><b>timestamp</b> : HiddenField
                                                    <br/><asp:textbox    id="timestamp" Text=""  runat="server" Width="400px" />
                                                    <br/>
                                                    <br/><b>signature</b> : HiddenField
                                                    <br/><asp:textbox   id="signature" runat="server" Width="400px" />
                                                    <br/>
                                                    <br/><b>MKEY(가맹점키)</b> : HiddenField
                                                    <br/><asp:TextBox  id="mKey" runat="server" Width="400px"/>
                                                </div>
                                                <br/><br/>
											    <b>***** 기본 옵션 *****</b>
											    <div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
                                                    <%-- <input type="hidden" style="width:100%;" value=""> --%>
                                                    <asp:HiddenField runat="server" id="gopaymethod" Value="" />
                                                    <b>offerPeriod</b> : 제공기간
                                                    <br/>ex)20150101-20150331, [Y2:년단위결제, M2:월단위결제, yyyyMMdd-yyyyMMdd : 시작일-종료일]
                                                    <br/><asp:textbox   id="offerPeriod" Text="20160101-20161231"  runat="server"  Width="400px" />
                                                    <br/>
                                                    <br/><b>acceptmethod :</b> 
                                                    <br/>ex) billauth(card) , billauth(hpp) 
                                                    <br/><asp:textbox  id="acceptmethod" Text="BILLAUTH(card)" runat="server" Width="500px" />
                                                    <br/><br/>
                                                    <b>결제일 알림 메세지</b> : 결제일 알림 메세지
												    <br/><asp:TextBox runat="server"  style="width:500px;" id="billPrint_msg" Text="고객님의 매월 결제일은 24일 입니다." />
                                                </div>
												<br/><br/>
											    <b>***** 표시 옵션 *****</b>
											    <div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
                                                    <br/><b>charset</b> : 리턴 인코딩
                                                    <br/>[UTF-8|EUC-KR] (default:UTF-8)
                                                    <br/><asp:textbox  id="charset" Text="" runat="server" Width="200px" />
                                                    <br/>
                                                    <br/><b>payViewType</b> : 결제창 표시방법
                                                    <br/>[overlay] (default:overlay)
                                                    <br/><asp:textbox  id="payViewType" Text="" runat="server" Width="200px"/>
                                                    <br/>
                                                    <br/><b>closeUrl</b> : payViewType='overlay','popup'시 취소버튼 클릭시 창닫기 처리 URL(가맹점에 맞게 설정)
                                                    <br/>close.jsp 샘플사용(생략가능, 미설정시 사용자에 의해 취소 버튼 클릭시 인증결과 페이지로 취소 결과를 보냅니다.)
                                                    <br/><asp:textbox  id="closeUrl" Text="http://127.0.0.1/close.aspx" runat="server" Width="400px" />
                                                    <br/>
                                                    <br/><b>popupUrl</b> : payViewType='popup'시 팝업을 띄울수 있도록 처리해주는 URL(가맹점에 맞게 설정)
                                                    <br/>popup.jsp 샘플사용(생략가능,payViewType='popup'으로 사용시에는 반드시 설정)
                                                    <br/><asp:textbox  id="popupUrl" Text="http://127.0.0.1/popup.aspx" runat="server" Width="400px"/>
                                                    <br/><br/>
                                                </div>
                                                <br /><br />
                                                <b>***** 추가 옵션 *****</b>
											    <div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
												    <br/><b>merchantData</b> : 가맹점 관리데이터(2000byte)
												    <br/>인증결과 리턴시 함께 전달됨
												    <br/><asp:textbox runat="server" style="width:100%;" id="merchantData" Text="" />
											    </div>
                                            </form>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
</body>
</html>
