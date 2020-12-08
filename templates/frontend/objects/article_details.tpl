{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *  Expected to be primary object on the page.
 *
 * Core components are produced manually below. Additional components can added
 * via plugins using the hooks provided:
 *
 * Templates::Article::Main
 * Templates::Article::Details
 *
 * @uses $article Article This article
 * @uses $publication Publication The publication being displayed
 * @uses $firstPublication Publication The first published version of this article
 * @uses $currentPublication Publication The most recently published version of this article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $licenseTerms string License terms
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published articles.
 * @uses $ccLicenseBadge string An image and text with details about the license
 *}

<article>
	<header class="row main__header">
		{* Notification that this is an old version *}
		{if $currentPublication->getId() !== $publication->getId()}
		<div role="alert">
			{capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
		{/if}

		<div class="col-md-9">
			{* Issue title & section *}
			<p class="metadata">
				<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
					{$issue->getIssueSeries()|escape}
					{if $issue->getShowTitle()}
					<br>
					<strong>{$issue->getLocalizedTitle()|escape}</strong>
					{/if}
				</a>
			</p>
			{if $section}
				<p class="metadata">{$section->getLocalizedTitle()|escape}</p>
			{/if}

			{* Article title *}
			<h1 class="main__title">
				{$publication->getLocalizedFullTitle()|escape}
			</h1>

			{* DOI *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<p class="metadata">
						<a href="{$doiUrl}">{$doiUrl}</a>
					</p>
				{/if}
			{/foreach}

			{* PubIds (other than DOI; requires plugins) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() == 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					<p class="metadata">
						<strong>{$pubIdPlugin->getPubIdDisplayType()|escape}</strong>
						{assign var="pubIdUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
						{if $pubIdUrl}
							<a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}" href="{$pubIdUrl}">
								{$pubIdUrl}
							</a>
						{else}
							{$pubId|escape}
						{/if}
					</p>
				{/if}
			{/foreach}

			{* Date published *}
			{if $publication->getData('datePublished')}
				<p class="metadata">
					{translate key="submissions.published"}
					{* If this is the original version *}
					{if $firstPublication->getID() === $publication->getId()}
						{$firstPublication->getData('datePublished')|date_format:$dateFormatShort}
					{* If this is an updated version *}
					{else}
						{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatShort dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatShort}
					{/if}
				</p>
			{/if}

			{* Authors & affiliations *}
			{assign var="authors" value=$publication->getData('authors')}
			{assign var="hasAffiliations" value=false}

			{foreach from=$authors item=author}
				{if $author->getLocalizedAffiliation()}
					{assign var="hasAffiliations" value=true}
					{break}
				{/if}
			{/foreach}

			{if $authors}
				<ul class="metadata">
					{foreach from=$authors name=authors item=authorString key=authorStringKey}
						{strip}
							<li>
								{$authorString->getFullName()|escape}
								{if $authorString->getOrcid()}
									<a href="{$authorString->getOrcid()|escape}">
										{if $orcidIcon}
											{$orcidIcon}
										{else}
											<img src="{$baseUrl}/{$orcidImageUrl}">
										{/if}
									</a>
								{/if}
							</li>
						{/strip}{if !$smarty.foreach.authors.last}, {/if}
					{/foreach}
				</ul>
			{/if}

			{if $hasAffiliations}
				<p>
					<button class="btn btn-secondary" type="button" data-toggle="collapse" data-target="#authorAffiliations" aria-expanded="false" aria-controls="authorAffiliations">
						{if $hasAffiliations > 1}
							{translate key="user.affiliations"}
						{else}
							{translate key="user.affiliation"}
						{/if}
				  </button>
				</p>
				<div class="collapse metadata" id="authorAffiliations">
					{foreach from=$authors item=author}
					 <div>
						<strong>{$author->getFullName()|escape}</strong><br>
						{$author->getLocalizedAffiliation()|escape}
						{if $author->getData('rorId')}
							<a class="article__rorImage" href="{$author->getData('rorId')|escape}">{$rorIdIcon}</a>
						{/if}
						<br><br>
					</div>
					{/foreach}
				</div>
			{/if}

		</div>

		<section class="col-md-3">
			{* Article or issue cover image *}
			{if $publication->getLocalizedData('coverImage') || ($issue && $issue->getLocalizedCoverImage())}
				{if $publication->getLocalizedData('coverImage')}
					{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
					<img
						class="img-fluid"
						src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
						alt="{$coverImage.altText|escape|default:''}"
					>
				{else}
					<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
						<img
							class="img-fluid"
							src="{$issue->getLocalizedCoverImageUrl()|escape}"
							alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}"
						>
					</a>
				{/if}
			{/if}
		</section>
	</header>

	<div class="row" id="mainArticleContent">
		<aside class="col-lg-3 order-lg-2">
      	{* Display other versions *}
			{if $publication->getData('datePublished')}
				{if count($article->getPublishedPublications()) > 1}
					<section>
						<h2>{translate key="submission.versions"}</h2>
						<ul>
							{foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
								{capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
								<li>
									{if $iPublication->getId() === $publication->getId()}
										{$name}
									{elseif $iPublication->getId() === $currentPublication->getId()}
										<a href="{url page="article" op="view" path=$article->getBestId()}">{$name}</a>
									{else}
										<a href="{url page="article" op="view" path=$article->getBestId()|to_array:"version":$iPublication->getId()}">{$name}</a>
									{/if}
								</li>
							{/foreach}
						</ul>
					</section>
				{/if}
			{/if}

			{* Categories article is in *}
			{if $categories}
				<section>
					<h2>{translate key="category.category"}</h2>
					<ul>
						{foreach from=$categories item=category}
							<li>
								<a href="{url router=$smarty.const.ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|escape}">{$category->getLocalizedTitle()|escape}</a>
							</li>
						{/foreach}
					</ul>
				</section>
			{/if}

			{* How to cite *}
			{if $citation}
				<section>
					<h2>{translate key="submission.howToCite"}</h2>
					<p></p>
					<div id="citationOutput" role="region" aria-live="polite" style="margin-bottom: 1.25rem;">
						{$citation}
					</div>
					<div class="dropdown">
						<button class="btn btn-primary dropdown-toggle" type="button" id="cslCitationFormatsButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" data-csl-dropdown="true">
							{translate key="submission.howToCite.citationFormats"}
						</button>
						<ul class="dropdown-menu" aria-labelledby="cslCitationFormatsButton">
							{foreach from=$citationStyles item="citationStyle"}
								<li class="dropdown-item">
									<a
											aria-controls="citationOutput"
											href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
											data-load-citation
											data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
										>
											{$citationStyle.title|escape}
										</a>
								</li>
							{/foreach}
						</ul>
					</div>

					{if count($citationDownloads)}
					<hr>
						<h3>
							{translate key="submission.howToCite.downloadCitation"}
						</h3>
						<ul>
							{foreach from=$citationDownloads item="citationDownload"}
								<li>
									<a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
										{$citationDownload.title|escape}
									</a>
								</li>
							{/foreach}
						</ul>
					{/if}
				</section>
			{/if}

			{* Licensing info *}
			{assign 'licenseTerms' $currentContext->getLocalizedData('licenseTerms')}
			{assign 'copyrightHolder' $publication->getLocalizedData('copyrightHolder')}
			{* overwriting deprecated variables *}
			{assign 'licenseUrl' $publication->getData('licenseUrl')}
			{assign 'copyrightYear' $publication->getData('copyrightYear')}

			{if $licenseTerms || $licenseUrl}
				<section>
					{if $licenseUrl}
						{if $ccLicenseBadge}
							{$ccLicenseBadge}
						{else}
							<a href="{$licenseUrl|escape}">
								{if $copyrightHolder}
									{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder|escape copyrightYear=$copyrightYear|escape}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{else}
						{$licenseTerms}
					{/if}
				</section>
			{/if}

			{call_hook name="Templates::Article::Details"}
		</aside>

		<div class="col-lg-9 order-lg-1" id="articleMainWrapper">
			<div class="article-details-main" id="articleMain">

				{* Abstract *}
				{if $publication->getLocalizedData('abstract')}
					<section>
						<h2>{translate key="article.abstract"}</h2>
						{$publication->getLocalizedData('abstract')|strip_unsafe_html}
					</section>
				{/if}

				{* Keywords *}
				{if !empty($publication->getLocalizedData('keywords'))}
					<section>
						<h2>
							{translate key="article.subject"}
						</h2>
						<p>
							{foreach name=keywords from=$publication->getLocalizedData('keywords') item=keyword}
								<span>{$keyword|escape}</span>{if !$smarty.foreach.keywords.last}, {/if}
							{/foreach}
						</p>
					</section>
				{/if}

				{* Article galleys *}
				{if $primaryGalleys}
					<section>
						{foreach from=$primaryGalleys item=galley}
							{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
						{/foreach}
					</section>
				{/if}

				{* Supplementary galleys *}
				{if $supplementaryGalleys}
					<section>
						<h2>{translate key="article.suppFiles"}</h2>
						{foreach from=$supplementaryGalleys item=galley}
							{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley isSupplementary="1"}
						{/foreach}
					</section>
				{/if}

				{* Author biographies *}
				{assign var="hasBiographies" value=false}
				{foreach from=$publication->getData('authors') item=author}
					{if $author->getLocalizedBiography()}
						{assign var="hasBiographies" value=true}
						{break}
					{/if}
				{/foreach}

				{if $hasBiographies}
					<hr>
					<section>
						<h2>
							{if $hasBiographies > 1}
								{translate key="submission.authorBiographies"}
							{else}
								{translate key="submission.authorBiography"}
							{/if}
						</h2>
						{foreach from=$publication->getData('authors') item=author}
							{if $author->getLocalizedBiography()}
								<h3>{$author->getFullName()|escape}</h3>
								<p>{$author->getLocalizedBiography()|strip_unsafe_html}</p>
							{/if}
						{/foreach}
					</section>
				{/if}

				{* References *}
				{if $parsedCitations || $publication->getData('citationsRaw')}
					<hr>
					<section>
						<h2>
							{translate key="submission.citations"}
						</h2>
						{if $parsedCitations}
							<ol>
								{foreach from=$parsedCitations item="parsedCitation"}
									<li>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</li>
								{/foreach}
							</ol>
						{else}
							<p>{$publication->getData('citationsRaw')|escape|nl2br}</p>
						{/if}
					</section>
				{/if}

				{call_hook name="Templates::Article::Main"}
			</div>
		</div>

	</div>
</article>
