<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="examens" />
<c:set var="pageTitle"   value="Démarrer un Examen" />
<jsp:include page="/WEB-INF/header.jsp" />

<div class="row justify-content-center">
<div class="col-md-6">
<div class="card">
    <div class="card-body">
        <div class="sec-title">
            <i class="bi bi-play-circle-fill text-primary" style="font-size:20px"></i>
            Démarrer un examen QCM
        </div>

        <form method="post" action="${pageContext.request.contextPath}/examens">
            <input type="hidden" name="action" value="begin">

            <div class="mb-3">
                <label class="form-label">Étudiant</label>
                <select name="num_etudiant" class="form-select" required>
                    <c:forEach var="et" items="${etudiants}">
                        <option value="${et.numEtudiant}">
                            ${et.nom} ${et.prenoms} (${et.niveau})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Année universitaire</label>
                <input type="text" name="annee_univ" class="form-control"
                       value="2024-2025" required placeholder="Ex: 2024-2025">
            </div>

            <div class="alert alert-info d-flex gap-2 align-items-start" style="font-size:12px">
                <i class="bi bi-info-circle-fill mt-1 flex-shrink-0"></i>
                <div>
                    Le système sélectionne <strong>10 questions aléatoires</strong>
                    parmi la banque de questions.<br>
                    L'étudiant répond question par question.
                    La note est calculée sur <strong>10</strong>.
                </div>
            </div>

            <div class="d-flex gap-2 justify-content-end mt-3">
                <a href="${pageContext.request.contextPath}/examens"
                   class="btn btn-outline-secondary">Annuler</a>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-play-fill"></i> Commencer l'examen
                </button>
            </div>
        </form>
    </div>
</div>
</div>
</div>

<jsp:include page="/WEB-INF/footer.jsp" />
