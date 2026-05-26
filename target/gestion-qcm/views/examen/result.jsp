<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="examens" />
<c:set var="pageTitle"   value="Résultat de l'examen" />
<jsp:include page="/WEB-INF/header.jsp" />

<%-- Récupération depuis la session --%>
<%
    com.gestionqcm.model.Etudiant etudiant =
        (com.gestionqcm.model.Etudiant) session.getAttribute("exam_etudiant");
    String  annee   = (String)  session.getAttribute("exam_annee");
    Integer score   = (Integer) session.getAttribute("exam_score");
    java.util.List<java.util.Map<String,String>> answers =
        (java.util.List<java.util.Map<String,String>>) session.getAttribute("exam_answers");
    if (etudiant == null || score == null) {
        response.sendRedirect(request.getContextPath() + "/examens");
        return;
    }
    request.setAttribute("etudiant", etudiant);
    request.setAttribute("annee",    annee);
    request.setAttribute("score",    score);
    request.setAttribute("answers",  answers);
%>

<div class="row justify-content-center">
<div class="col-md-8">

    <!-- Score principal -->
    <div class="card mb-3 text-center">
        <div class="card-body py-4">
            <div style="font-size:42px;font-weight:700;color:${score >= 5 ? '#059669' : '#EF4444'}">
                ${score}/10
            </div>
            <div class="text-muted mt-1" style="font-size:13px">
                ${etudiant.nom} ${etudiant.prenoms} &nbsp;·&nbsp; ${annee}
            </div>
            <div class="mt-2">
                <c:choose>
                    <c:when test="${score >= 9}"><span class="badge bg-success">Très bien</span></c:when>
                    <c:when test="${score >= 7}"><span class="badge bg-primary">Bien</span></c:when>
                    <c:when test="${score >= 5}"><span class="badge bg-warning text-dark">Passable</span></c:when>
                    <c:otherwise><span class="badge bg-danger">Insuffisant</span></c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Détail question par question -->
    <div class="card mb-3">
        <div class="card-body">
            <div class="sec-title">
                <i class="bi bi-list-ul"></i>Détail des réponses
            </div>
            <c:forEach var="a" items="${answers}" varStatus="st">
                <div class="${a['correct'] == 'true' ? 'result-ok' : 'result-ko'}">
                    <div style="font-weight:600;margin-bottom:3px">
                        ${st.index + 1}. ${a['question']}
                    </div>
                    <div style="font-size:11px">
                        Votre réponse :
                        <strong style="color:${a['correct'] == 'true' ? '#059669' : '#EF4444'}">
                            ${a['selectedTexte']}
                        </strong>
                        <c:if test="${a['correct'] != 'true'}">
                            &nbsp;—&nbsp;
                            Bonne réponse :
                            <strong style="color:#059669">${a['bonneTexte']}</strong>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Bouton enregistrement -->
    <form method="post" action="${pageContext.request.contextPath}/examens">
        <input type="hidden" name="action" value="save">
        <div class="d-flex gap-2 justify-content-end">
            <button type="submit" class="btn btn-success">
                <i class="bi bi-envelope-fill"></i>
                Enregistrer &amp; Envoyer l'email
            </button>
        </div>
    </form>

</div>
</div>

<jsp:include page="/WEB-INF/footer.jsp" />
