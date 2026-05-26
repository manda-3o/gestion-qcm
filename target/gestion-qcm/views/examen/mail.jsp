<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="examens" />
<c:set var="pageTitle"   value="Email envoyé" />
<jsp:include page="/WEB-INF/header.jsp" />

<%-- Support accès direct depuis liste (via paramètres URL) --%>
<c:if test="${empty emailDest}">
    <c:set var="emailDest"    value="${param.email}"/>
    <c:set var="emailNom"     value="${param.nom}"/>
    <c:set var="emailNote"    value="${param.note}"/>
    <c:set var="emailAnnee"   value="${param.annee}"/>
    <c:set var="emailMention" value="${param.note >= 9 ? 'Très bien' : param.note >= 7 ? 'Bien' : param.note >= 5 ? 'Passable' : 'Insuffisant'}"/>
</c:if>

<div class="row justify-content-center">
<div class="col-md-7">
<div class="card">
    <div class="card-body">

        <div class="sec-title" style="color:#059669">
            <i class="bi bi-envelope-check-fill" style="font-size:20px"></i>
            Email envoyé automatiquement
        </div>

        <div class="mail-box">
            <div class="text-muted mb-1" style="font-size:12px">
                De : <strong>noreply@gestionqcm.univ.mg</strong>
            </div>
            <div class="text-muted mb-1" style="font-size:12px">
                À : <strong>${emailDest}</strong>
            </div>
            <div class="text-muted mb-3" style="font-size:12px">
                Objet : <strong>Résultat de votre examen QCM — ${emailAnnee}</strong>
            </div>
            <hr>
            <p>Bonjour <strong>${emailNom}</strong>,</p>
            <p class="mt-2">
                Nous avons le plaisir de vous informer de votre résultat à l'examen QCM
                pour l'année universitaire <strong>${emailAnnee}</strong>.
            </p>
            <p class="mt-3">
                Votre note :
                <span style="font-size:24px;font-weight:700;color:${emailNote >= 5 ? '#059669' : '#EF4444'}">
                    ${emailNote} / 10
                </span>
            </p>
            <p class="mt-1">
                Mention :
                <c:choose>
                    <c:when test="${emailNote >= 9}"><span class="badge bg-success">Très bien</span></c:when>
                    <c:when test="${emailNote >= 7}"><span class="badge bg-primary">Bien</span></c:when>
                    <c:when test="${emailNote >= 5}"><span class="badge bg-warning text-dark">Passable</span></c:when>
                    <c:otherwise><span class="badge bg-danger">Insuffisant</span></c:otherwise>
                </c:choose>
            </p>
            <p class="mt-4 text-muted border-top pt-3" style="font-size:11px">
                Ce message est généré automatiquement par le système GestionQCM.
                Merci de ne pas y répondre.
            </p>
        </div>

        <div class="d-flex justify-content-end mt-3">
            <a href="${pageContext.request.contextPath}/examens"
               class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Retour aux examens
            </a>
        </div>

    </div>
</div>
</div>
</div>

<jsp:include page="/WEB-INF/footer.jsp" />
