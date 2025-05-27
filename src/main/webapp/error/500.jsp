
<%@ page isErrorPage="true" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Error del Servidor (500)</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #f8d7da;
            color: #721c24;
            padding: 2rem;
        }
        .error-box {
            background-color: #f5c6cb;
            border: 1px solid #f5c2c7;
            padding: 1rem;
            border-radius: 8px;
        }
        pre {
            background-color: #fff3f4;
            padding: 1rem;
            overflow-x: auto;
            border: 1px solid #f1b0b7;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="error-box">
        <h1>Error interno del servidor (500)</h1>
        <p>Ha ocurrido un problema en el servidor.</p>

        <h3>Mensaje:</h3>
        <p><%= exception != null ? exception.getMessage() : "Sin mensaje específico." %></p>

        <h3>Stack Trace:</h3>
        <pre>
<%
    if (exception != null) {
        exception.printStackTrace(new java.io.PrintWriter(out));
    } else {
        out.println("No se encontró una excepción.");
    }
%>
        </pre>
    </div>
</body>
</html>

