<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="classement" />
<c:set var="pageTitle"   value="Classement &amp; Statistiques" />
<jsp:include page="/WEB-INF/header.jsp" />

<!-- ─── Stats 3 colonnes ─────────────────────────────────── -->
<div class="row g-3 mb-3">
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon" style="background:#7C3AED"><i class="bi bi-bar-chart"></i></div>
            <div>
                <div class="stat-val">${moyGenerale}/10</div>
                <div class="stat-lbl">Moyenne générale</div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon" style="background:#059669"><i class="bi bi-check-circle"></i></div>
            <div>
                <div class="stat-val">
                    <c:choose>
                        <c:when test="${nbExamens > 0}">
                            <fmt:formatNumber value="${nbPassed * 100 / nbExamens}" maxFractionDigits="0"/>%
                        </c:when>
                        <c:otherwise>0%</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-lbl">Taux de réussite</div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon" style="background:#D97706"><i class="bi bi-star"></i></div>
            <div>
                <div class="stat-val">${bestNote}/10</div>
                <div class="stat-lbl">Meilleure note</div>
            </div>
        </div>
    </div>
</div>

<!-- ─── Classement ────────────────────────────────────────── -->
<div class="card">
    <div class="card-body">
        <div class="sec-title">
            <i class="bi bi-trophy-fill text-warning"></i>
            Classement par ordre de mérite
        </div>
    </div>
    <div class="card-body p-0">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Rang</th><th>Étudiant</th><th>Niveau</th>
                    <th>Meilleure note</th><th>Moyenne</th><th>Examens</th><th>Email</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty classement}">
                    <tr><td colspan="7" class="text-center text-muted py-4">Aucun examen enregistré</td></tr>
                </c:when>
                <c:otherwise>
                <c:forEach var="ex" items="${classement}" varStatus="st">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${st.index == 0}">
                                <span class="medal" style="background:#FEF3C7;font-size:18px">🥇</span>
                            </c:when>
                            <c:when test="${st.index == 1}">
                                <span class="medal" style="background:#F3F4F6;font-size:18px">🥈</span>
                            </c:when>
                            <c:when test="${st.index == 2}">
                                <span class="medal" style="background:#FEE2E2;font-size:18px">🥉</span>
                            </c:when>
                            <c:otherwise>
                                <span class="medal"
                                      style="background:#F3F4F6;color:#6B7280;font-size:11px;font-weight:700">
                                    ${st.index + 1}
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <span class="avatar" style="background:#3B5BDB">
                            ${ex.nomEtudiant.substring(0,1)}${ex.prenomsEtudiant.substring(0,1)}
                        </span>
                        <span style="font-weight:600">${ex.nomEtudiant} ${ex.prenomsEtudiant}</span>
                        <br>
                        <span class="text-muted" style="font-size:10px">${ex.numEtudiant}</span>
                    </td>
                    <td><span class="badge badge-niveau">${ex.niveauEtudiant}</span></td>
                    <td>
                        <span class="badge ${ex.note >= 5 ? 'badge-note-ok' : 'badge-note-ko'}">
                            ${ex.note}/10
                        </span>
                    </td>
                    <td class="text-muted fw-semibold">${ex.note}/10</td>
                    <td class="text-muted">${ex.numExam > 0 ? '1+' : '1'} examen(s)</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/examens?action=mail&email=${ex.emailEtudiant}&nom=${ex.nomEtudiant}+${ex.prenomsEtudiant}&note=${ex.note}&annee=${ex.anneeUniv}"
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
