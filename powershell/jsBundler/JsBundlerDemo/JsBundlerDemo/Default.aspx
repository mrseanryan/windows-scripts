<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="JsBundlerDemo.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>JsBundler Demo</title>
    <script src="Scripts/jquery-2.0.3.min.js"></script>
    <script src="Scripts/FibonaciBundle.js"></script>
    <script src="Styles/FileNotInBundle.min.js"></script>

    <link href="Styles/Styles.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>JsBundler Demo</h1>

            <div id="output"></div>
        </div>
    </form>
</body>
</html>
