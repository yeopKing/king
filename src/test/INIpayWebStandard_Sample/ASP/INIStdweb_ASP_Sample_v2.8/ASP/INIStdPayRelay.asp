<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
        <script>
        	function Submit_me(){
       		frm.target="INIpayStd_Return";
        	frm.submit();
       		self.close();
        }
        </script>
    </head>

    <body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0 onload="Submit_me()">
<%
'===== ��ܿ��� ���� ���� �ٽ� ����� ==========
'payViewType�� popup���� ���� return ���� ������ ���� *request returnUrl page 
Response.Write "<form name='frm' method='post' action='/aspSample/INIStdPayReturn.asp'>"&Chr(10)
i=0
For each item in Request.Form
    for i = 1 to Request.Form(item).Count
		Response.Write "<input type='text' name='"&item&"' value='"&Request.Form(item)(i)&"'>"&Chr(10)
 Next
Next
	Response.Write "</form>"
%>
    </body>
</html>