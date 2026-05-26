<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="dashboard" />
<c:set var="pageTitle"   value="Tableau de bord" />
<jsp:include page="/WEB-INF/header.jsp" />

<!-- ─── Stats Cards ──────────────────────────────────────── -->
<div class="stats-grid">

    <div class="stat-card">
        <div class="stat-icon" style="background:#3B5BDB"><i class="bi bi-people"></i></div>
        <div>
            <div class="stat-val">${nbEtudiants}</div>
            <div class="stat-lbl">Étudiants inscrits</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon" style="background:#D97706"><i class="bi bi-journal-bookmark"></i></div>
        <div>
            <div class="stat-val">${nbQuestions}</div>
            <div class="stat-lbl">Questions QCM</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon" style="background:#059669"><i class="bi bi-clipboard-check"></i></div>
        <div>
            <div class="stat-val">${nbExamens}</div>
            <div class="stat-lbl">Examens passés</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon" style="background:#7C3AED"><i class="bi bi-bar-chart"></i></div>
        <div>
            <div class="stat-val">${moyGenerale}/10</div>
            <div class="stat-lbl">Moyenne générale</div>
        </div>
    </div>

</div>

<!-- ─── Grille 2 colonnes ─────────────────────────────────── -->
<div class="row g-3">

    <!-- Effectif par niveau -->
    <div class="col-md-6">
        <div class="card h-100">
            <div class="card-body">
                <div class="sec-title"><i class="bi bi-bar-chart text-primary"></i>Effectif par Niveau</div>
                <c:forEach var="entry" items="${effectifs}">
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1" style="font-size:11px">
                            <strong>${entry.key}</strong>
                            <span class="text-muted">${entry.value} étudiant(s)</span>
                        </div>
                        <div class="prog-wrap">
                            <div class="prog-fill"
                                 style="width:${nbEtudiants > 0 ? (entry.value * 100 / nbEtudiants) : 0}%"></div>
                        </div>
                    </div>
                </c:forEach>
                <div class="d-flex justify-content-between mt-3 pt-2 border-top" style="font-size:11px">
                    <span class="text-muted">Taux de réussite (≥5/10)</span>
                    <c:choose>
                        <c:when test="${nbExamens > 0}">
                            <strong class="text-success">
                                <fmt:formatNumber value="${nbPassed * 100 / nbExamens}" maxFractionDigits="0"/>%
                            </strong>
                        </c:when>
                        <c:otherwise><strong>0%</strong></c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Derniers résultats -->
    <div class="col-md-6">
        <div class="card h-100">
            <div class="card-body">
                <div class="sec-title"><i class="bi bi-clock-history text-warning"></i>Derniers résultats</div>
                <c:choose>
                    <c:when test="${empty derniersResultats}">
                        <p class="text-muted text-center py-3">Aucun examen enregistré.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-borderless mb-0">
                            <thead>
                                <tr>
                                    <th>Étudiant</th>
                                    <th>Note</th>
                                    <th>Année</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ex" items="${derniersResultats}">
                                <tr>
                                    <td>
                                        <span class="avatar"
                                              style="background:${ex.note ge 7 ? '#3B5BDB' : '#EF4444'}">
                                            ${ex.nomEtudiant.substring(0,1)}${ex.prenomsEtudiant.substring(0,1)}
                                        </span>
                                        ${ex.nomEtudiant} ${ex.prenomsEtudiant}
                                    </td>
                                    <td>
                                        <span class="badge ${ex.note >= 5 ? 'badge-note-ok' : 'badge-note-ko'}">
                                            ${ex.note}/10
                                        </span>
                                    </td>
                                    <td class="text-muted">${ex.anneeUniv}</td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <a href="${pageContext.request.contextPath}/examens"
                           class="btn btn-outline-secondary btn-sm w-100 mt-2">
                            Voir tout <i class="bi bi-arrow-right"></i>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

</div><!-- /row -->

<jsp:include page="/WEB-INF/footer.jsp" />
