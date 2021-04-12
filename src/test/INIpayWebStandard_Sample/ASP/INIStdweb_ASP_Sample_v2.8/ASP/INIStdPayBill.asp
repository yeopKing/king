<!--#include virtual="/include/signature.asp"-->
<!--#include virtual="/include/function.asp"-->
<%

'		*** ������ ����üũ�� signature ���� ***
'		* timestamp�� �ݵ�� signature������ ����� timestamp ���� timestamp input�� �״�� ����Ͽ�����


'############################################
' 1.���� �ʵ� �� ����(***������ ���߼���***)
'############################################

' ���⿡ ������ ���� Form �ʵ忡 ������ ������ ����
	maid					= "INIBillTst"		' ������ ID(������ ������ ����)					
	
'����
	signKey			    = "SU5JTElURV9UUklQTEVERVNfS0VZU1RS"	' �������� ������ �� ǥ�� ����Ű(������ ������ ����)
	
	'timestamp			= time_stamp()
	correct 				= "09"								' ǥ�ؽÿ��� ���̸� 2�ڸ� ���ڷ� �Է� (��: ���ѹα��� ǥ�ؽÿ� 9�ð� �����̹Ƿ� 09) 
	timestamp				= time_stamp(correct) 
	
	oid					= maid&"_"&timestamp											' ������ �ֹ���ȣ(���������� ���� ����)
	price					= "1000"																' ��ǰ����(Ư����ȣ ����, ���������� ���� ����)

	'###############################################
	' 2. ������ Ȯ���� ���� signKey�� �ؽð����� ���� (SHA-256��� ���)
	'###############################################
	mKey = MakeSignature(signKey)
	
	'###############################################
	' 2.signature ����
	'###############################################



	signParam = "oid="&oid
	signParam = signParam&"&price="&price
	signParam = signParam&"&timestamp="&timestamp



	' signature ������ ���� (��⿡�� �ڵ����� signParam�� ���ĺ� ������ ������ NVP ������� ������ hash)
	signature = MakeSignature(signParam)
	
	
	
	' ������ URL���� ������ �κ��� ���´�. 
	' Ex) returnURL�� http://test.inicis.com/INIpayStdSample/INIStdPayReturn.jsp ���
	' http://test.inicis.com/INIpayStdSample ������ �����Ѵ�.
	
		siteDomain = "http://127.0.0.1:8080/INIpayStdSample" '������ ������ �Է�
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<style type="text/css">
		body { background-color: #efefef;}
		body, tr, td {font-size:9pt; font-family:����,verdana; color:#433F37; line-height:19px;}
		table, img {border:none}
	</style>

	<!-- �̴Ͻý� ǥ�ذ��� js -->
<%
	'�������� URL�� http: �ΰ�� js URL�� http://stdpay.inicis.com/stdjs/INIStdPay.js �� �����մϴ�.
	'���������� ����ϴ� �ɸ��ͼ��� EUC-KR �� ��� charset="UTF-8"�� UTF-8 �� ��� charset="UTF-8"�� �����մϴ�.
%>	
	<script language="javascript" type="text/javascript" src="https://stgstdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>
	<script type="text/javascript">
		function paybtn() {
		    INIStdPay.pay('SendPayForm_id');
		}
		
		function cardShow(){
			document.getElementById("acceptmethod").value = "BILLAUTH(card):FULLVERIFY";
		}
		
		function hppShow(){
			document.getElementById("acceptmethod").value = "BILLAUTH(HPP):HPP(1)";
		}
	</script>
</head>
<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0>
	
	<div style="padding:10px;background-color:#f3f3f3;width:100%;font-size:13px;color: #ffffff;background-color: #000000;text-align: center">
		�̴Ͻý� ǥ�ذ��� �ſ�ī�� ����Ű �߱� ����
	</div>
	
	<table width="650" border="0" cellspacing="0" cellpadding="0" style="padding:10px;" align="center">
		<tr>
			<td bgcolor="6095BC" align="center" style="padding:10px">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" style="padding:20px">

					<tr>
						<td>
							�� �������� INIpay Standard ������û�� ���� �����Դϴ�.<br/>
							<br/>
							����ó���� ���� action���� ��� ������ Import �� ��ũ��Ʈ�� ���� �ڵ�ó���˴ϴ�.<br/>

							<br/>
							Form�� ������ ��� �ʵ��� name�� ��ҹ��� �����ϸ�,<br/>
							�� Sample�� ������ ���ؼ� ������ Form�� �׽�Ʈ / ���ص��⸦ ���ؼ� ��� type="text"�� �����Ǿ� �ֽ��ϴ�.<br/>
							��� ����ÿ��� �Ϻ� ���������� �ʿ信 ���� ����ڰ� �����ϴ� ��츦 �����ϰ�<br/>
							��� type="hidden"���� �����Ͽ� ����Ͻñ� �ٶ��ϴ�.<br/>

							<br/>
							<font color="#336699"><strong>�Բ� �����Ǵ� �Ŵ����� �����Ͽ� �ۼ� �����Ͻñ� �ٶ��ϴ�.</strong></font>
							<br/><br/>
						</td>
					</tr>
					<tr>
                            <td>
								<input type="radio" id="card" name="payTypeChk" value="card" onclick="cardShow()" checked="checked">ī�����
								<input type="radio" id="hpp"  name="payTypeChk" value="hpp"  onclick="hppShow()" >�޴�������
							</td>
                        </tr>
					<tr>
						<td >
							<!-- ������û -->
							<button onclick="paybtn();" style="padding:10px">������û</button>
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td style="text-align:left;">
										<form id="SendPayForm_id" name="" method="POST" >
										
											<br/><b>***** �� �� *****</b>
											<div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">

												<br/><b>version</b> :
												<br/><input  style="width:100%;" name="version" value="1.0" >

												<br/><b>mid</b> :
												<br/><input  style="width:100%;" name="mid" value="<%=maid%>" >
													
												<br/><b>goodname</b> :
												<br/><input  style="width:100%;" name="goodname" value="�׽�Ʈ" >

												<br/><b>oid</b> :
												<br/><input  style="width:100%;" name="oid" value="<%=oid%>" >

												<br/><b>price</b> :
												<br/><input  style="width:100%;" name="price" value="<%=price%>" >

												<br/><b>currency</b> :
												<br/>[WON|USD]
												<br/><input  style="width:100%;" name="currency" value="WON" >

												<br/><b>buyername</b> :
												<br/><input  style="width:100%;" name="buyername" value="ȫ�浿" >

												<br/><b>buyertel</b> :
												<br/><input  style="width:100%;" name="buyertel" value="010-1234-5678" >

												<br/><b>buyeremail</b> :
												<br/><input  style="width:100%;" name="buyeremail" value="test@inicis.com" >

												<input type="hidden" style="width:100%;" name="timestamp" value="<%=timestamp%>" >


												<input type="hidden" style="width:100%;" name="signature" value="<%=signature%>" >

												<br/><b>returnUrl</b> :
												<br/><input  style="width:100%;" name="returnUrl" value="<%=siteDomain%>/INIStdPayReturn.asp" >
												<!--
                            payViewType�� popup�� ��� crossDomain�̽��� ��ȸó�� 
                            <input  style="width:100%;" name="returnUrl" value="<%=siteDomain%>/INIStdPayRelay.asp" >
												-->
												<input type="hidden"  name="mKey" value="<%=mKey%>" >

											</div>

											<br/><br/>
											<b>***** �⺻ �ɼ� *****</b>
											<div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
												<b>gopaymethod</b> : ���� ���� ����
												<br/>ex) Card (��� ���� ������ �������� ���� ��� ������ ����)
												<br/>��� ������ �Է� ��
												<br/>Card,DirectBank,HPP,Vbank,kpay,Swallet,Paypin,EasyPay,PhoneBill,GiftCard,EWallet
												<br/>onlypoint,onlyocb,onyocbplus,onlygspt,onlygsptplus,onlyupnt,onlyupntplus
												<br/><input  style="width:100%;" name="gopaymethod" value="" >
												<br/><br/>

												<br/>
												<b>offerPeriod</b> : �����Ⱓ
												<br/>ex)20150101-20150331, [Y2:���������, M2:����������, yyyyMMdd-yyyyMMdd : ������-������]
												<br/><input  style="width:100%;" name="offerPeriod" value="20150101-20150331" >
												<br/><br/>
												
												<br/><b>acceptmethod : ��Ÿ �ɼ� ���� �� ������ �������Ǻ� ���� ������ ":"
											
												<br/><input style="width:100%;" id="acceptmethod" name="acceptmethod" value="BILLAUTH(card)" > 
												<b>������ �˸� �޼���</b> : ������ �˸� �޼���
												<br/><input  style="width:100%;" id="billPrint_msg" name="billPrint_msg" value="������ �ſ� �������� 24�� �Դϴ�." >
												<br/>
											</div>

											<br/><br/>
											<b>***** ǥ�� �ɼ� *****</b>
											<div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
												<br/><b>languageView</b> : �ʱ� ǥ�� ���
												<br/>[ko|en] (default:ko)
												<br/><input style="width:100%;" name="languageView" value="" >

												<br/><b>charset</b> : ���� ���ڵ�
												<br/>[UTF-8|EUC-KR] (default:UTF-8)
												<br/><input style="width:100%;" name="charset" value="EUC-KR" >

												<br/><b>payViewType</b> : ����â ǥ�ù��
												<br/>[overlay] (default:overlay)
												<br/><input style="width:100%;" name="payViewType" value="" >

												<br/><b>closeUrl</b> : payViewType='overlay','popup'�� ��ҹ�ư Ŭ���� â�ڱ� ó�� URL(�������� �°� ����)
												<br/>close.asp ���û��(��������, �̼����� ����ڿ� ���� ��� ��ư Ŭ���� ������� �������� ��� ����� �����ϴ�.)
												<br/><input style="width:100%;" name="closeUrl" value="<%=siteDomain%>/close.asp" >

												<br/><b>popupUrl</b> : payViewType='popup'�� �˾��� ���� �ֵ��� ó�����ִ� URL(�������� �°� ����)
												<br/>popup.asp ���û��(��������,payViewType='popup'���� ���ÿ��� �ݵ�� ����)
												<br/><input style="width:100%;" name="popupUrl" value="<%=siteDomain%>/popup.asp" >

											</div>
											
											
											<br/><br/>
											<b>***** �߰� �ɼ� *****</b>
											<div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
												<br/><b>merchantData</b> : ������ ����������(2000byte)
												<br/>������� ���Ͻ� �Բ� ���޵�
												<br/><input  style="width:100%;" name="merchantData" value="" >
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