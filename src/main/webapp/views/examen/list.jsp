<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="examens" />
<c:set var="pageTitle"   value="Examens &amp; Notes" />
<jsp:include page="/WEB-INF/header.jsp" />

<!-- ─── Filtre + bouton lancer ───────────────────────────── -->
<div class="d-flex gap-2 mb-3 align-items-center flex-wrap">
    <form method="get" action="${pageContext.request.contextPath}/examens" class="d-flex gap-2">
        <select name="annee" class="form-select" style="width:160px" onchange="this.form.submit()">
            <option value="">Toutes les années</option>
            <c:forEach var="a" items="${annees}">
                <option value="${a}" ${filterAnnee == a ? 'selected' : ''}>${a}</option>
            </c:forEach>
        </select>
    </form>
    <a href="${pageContext.request.contextPath}/examens?action=start"
       class="btn btn-primary btn-sm ms-auto">
        <i class="bi bi-play-fill"></i> Lancer un examen
    </a>
</div>

<!-- ─── Tableau des notes ─────────────────────────────────── -->
<div class="card">
    <div class="card-body">
        <div class="sec-title">
            <i class="bi bi-list-check text-primary"></i>
            Liste des notes —
            <span class="badge bg-primary">${examens.size()} résultat(s)</span>
        </div>
    </div>
    <div class="card-body p-0">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Étudiant</th><th>Niveau</th><th>Note</th>
                    <th>Mention</th><th>Année univ.</th><th>Email</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty examens}">
                    <tr><td colspan="6" class="text-center text-muted py-4">Aucun examen enregistré</td></tr>
                </c:when>
                <c:otherwise>
                <c:forEach var="ex" items="${examens}">
                <tr>
                    <td>
                        <span class="avatar" style="background:#3B5BDB">
                            ${ex.nomEtudiant.substring(0,1)}${ex.prenomsEtudiant.substring(0,1)}
                        </span>
                        ${ex.nomEtudiant} ${ex.prenomsEtudiant}
                    </td>
                    <td><span class="badge badge-niveau">${ex.niveauEtudiant}</span></td>
                    <td>
                        <span class="badge ${ex.note >= 5 ? 'badge-note-ok' : 'badge-note-ko'}">
                            ${ex.note}/10
                        </span>
                    </td>
                    <td>
                        <span class="badge bg-${ex.mentionClass}-subtle text-${ex.mentionClass}">
                            ${ex.mention}
                        </span>
                    </td>
                    <td class="text-muted">${ex.anneeUniv}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/examens?action=mail&email=${ex.emailEtudiant}&nom=${ex.nomComplet}&note=${ex.note}&annee=${ex.anneeUniv}"
                           class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-envelope"></i>
                        </a>
                    </td>
                </tr>
                </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/footer.jsp" />
