using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class INIStdPayBill : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 여기에 사용자 코드를 배치하여 페이지를 초기화합니다.
        if (!Page.IsPostBack)
            StartINIStd();

    }

    private void StartINIStd()
    {
        //각 필드 설정
        string strMid = "INIBillTst";
        mid.Text = strMid;

        string strVersion = "1.0";
        version.Text = strVersion;

        string strGoodName = "테스트";
        goodname.Text = strGoodName;

        string strPrice = "1000";
        price.Text = strPrice;

        string strCurrency = "WON";
        currency.Text = strCurrency;

        string strBuyerName = "홍길동";
        buyername.Text = strBuyerName;

        string strBuyerTel = "010-1234-1234";
        buyertel.Text = strBuyerTel;

        string strBuyerEmail = "test@inicis.com";
        buyeremail.Text = strBuyerEmail;



        // TimeStamp 생성
        string timeTemp = "" + DateTime.UtcNow.Subtract(DateTime.MinValue.AddYears(1969)).TotalMilliseconds;
        string[] artime = timeTemp.Split('.');
        timestamp.Text = artime[0];

        oid.Text = mid.Text + "_" + timestamp.Text;

        //Signature 생성 - 알파벳 순으로 정렬후 hash
        string param = "oid=" + oid.Text + "&price=" + price.Text + "&timestamp=" + timestamp.Text;
        signature.Text = ComputeHash(param);

        //closeURL
        //string close = "http://127.0.0.1/close.aspx";
        //closeUrl.Text = close;

        //popupURL
        //string popup = "http://127.0.0.1/popup.aspx";
        //popupUrl.Text = popup;

        //가맹점 전환 페이지 설정
        string strReturnUrl = "http://127.0.0.1/INIStdPayReturn.aspx";
        //string strReturnUrl = "http://127.0.0.1/INIStdPayRelay.aspx";
        returnUrl.Text = strReturnUrl;

        // 가맹점확인을 위한 signKey 를 해쉬값으로 변경(SHA-256)
        string signKey = "SU5JTElURV9UUklQTEVERVNfS0VZU1RS";   // 가맹점에 제공된 키(이니라이트키) (가맹점 수정후 고정) !!!절대!! 전문 데이터로 설정금지
        mKey.Text = ComputeHash(signKey);



    }

    // SHA256  256bit 암호화
    private string ComputeHash(string input)
    {
        System.Security.Cryptography.SHA256 algorithm = System.Security.Cryptography.SHA256Managed.Create();
        Byte[] inputBytes = Encoding.UTF8.GetBytes(input);
        Byte[] hashedBytes = algorithm.ComputeHash(inputBytes);

        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < hashedBytes.Length; i++)
        {
            sb.Append(String.Format("{0:x2}", hashedBytes[i]));
        }


        return sb.ToString();
    }
}