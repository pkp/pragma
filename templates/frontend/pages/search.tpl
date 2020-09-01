{**
 * templates/frontend/pages/search.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to search and view search results.
 *
 * @uses $query Value of the primary search query
 * @uses $authors Value of the authors search filter
 * @uses $dateFrom Value of the date from search filter (published after).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $dateTo Value of the date to search filter (published before).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $yearStart Earliest year that can be used in from/to filters
 * @uses $yearEnd Latest year that can be used in from/to filters
 *}
{include file="frontend/components/header.tpl" pageTitle="common.search"}

<main class="container main__content" id="main">
	<header class="main__header">
		<h1 class="main__title">
			{if $query}
				{translate key="plugins.themes.pragma.search.resultsFor" query=$query|escape}
			{elseif $authors}
				{translate key="plugins.themes.pragma.search.resultsFor" query=$authors|escape}
			{else}
				{translate key="common.search"}
			{/if}
		</h1>
	</header>

	<div class="row justify-content-lg-center">
		<aside class="col-md-4">
			<h2 class="sr-only">{translate key="search.advancedFilters"}</h2>
			{capture name="searchFormUrl"}{url op="search" escape=false}{/capture}
			{$smarty.capture.searchFormUrl|parse_url:$smarty.const.PHP_URL_QUERY|parse_str:$formUrlParameters}
			<form class="cmp_form" method="get" action="{$smarty.capture.searchFormUrl|strtok:"?"|escape}">
				{foreach from=$formUrlParameters key=paramKey item=paramValue}
					<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}"/>
				{/foreach}

				<div class="form-group">
					<label for="query">
						{translate key="common.searchQuery"}
					</label>
					<input type="search" class="form-control" id="query" name="query" value="{$query|escape}" placeholder="{translate key='common.keywords'}">
				</div>
				<div class="form-group">
					<label for="authors">
						{translate key="search.author"}
					</label>
					<input type="text" class="form-control" id="authors" name="authors" value="{$authors|escape}" placeholder="{translate key='common.name'}">
				</div>
				<div class="form-group">
					<label for="dateFromYear">
						{translate key="search.dateFrom"}
					</label>
					<div class="form-row">
						{html_select_date class="col form-control" prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd year_empty="{translate key='common.year'}" month_empty="{translate key='common.month'}" day_empty="{translate key='common.day'}" field_order="YMD"}
					</div>
				</div>
				<div class="form-group">
					<label for="dateToYear">
						{translate key="search.dateTo"}
					</label>
					<div class="form-row">
						{html_select_date class="col form-control" prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd year_empty="{translate key='common.year'}" month_empty="{translate key='common.month'}" day_empty="{translate key='common.day'}" field_order="YMD"}
					</div>
				</div>
				<div class="form-group">
					<button class="btn btn-primary" type="submit">{translate key="common.search"}</button>
				</div>
			</form>
		</aside>

		<div class="col-md-8">
			{* No results found *}
			{if $results->wasEmpty()}
				{if $error}
					<div role="alert">{$error|escape}</div>
				{else}
					<div role="alert">{translate key="search.noResults"}</div>
				{/if}

			{* Results pagination *}
			{else}
				{iterate from=results item=result}
					{include file="frontend/objects/article_summary.tpl" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true}
				{/iterate}
				<div>
					{page_info iterator=$results}
					{page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors title=$title abstract=$abstract galleyFullText=$galleyFullText discipline=$discipline subject=$subject type=$type coverage=$coverage indexTerms=$indexTerms dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear orderBy=$orderBy orderDir=$orderDir}
				</div>
			{/if}
		</div>
	</div>

</main>

{include file="frontend/components/footer.tpl"}
