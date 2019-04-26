{**
 * templates/frontend/pages/search.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
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

<div class="container">
	<h1>
		{if $query}
			{translate key="plugins.themes.healthSciences.search.resultsFor" query=$query|escape}
		{elseif $authors}
			{translate key="plugins.themes.healthSciences.search.resultsFor" query=$authors|escape}
		{else}
			{translate key="common.search"}
		{/if}
	</h1>
	<div class="row justify-content-lg-center">
		<div class="col-lg-8">
			<div>

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
						{include file="frontend/objects/article_summary.tpl" article=$result.publishedArticle journal=$result.journal showDatePublished=true hideGalleys=true}
					{/iterate}
					<div>
						{page_info iterator=$results}
						{page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors title=$title abstract=$abstract galleyFullText=$galleyFullText discipline=$discipline subject=$subject type=$type coverage=$coverage indexTerms=$indexTerms dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear orderBy=$orderBy orderDir=$orderDir}
					</div>
				{/if}
			</div>
		</div>
		<div class="col-lg-4">
			<div>
				<h2>{translate key="plugins.themes.healthSciences.search.params"}</h2>
				<form method="post" action="{url op="search"}">
					{csrf}
					<div class="form-group">
						<label for="query">
							{translate key="common.searchQuery"}
						</label>
						<input type="text" class="form-control" id="query" name="query" value="{$query|escape}">
					</div>
					<div class="form-group">
						<label for="authors">
							{translate key="search.author"}
						</label>
						<input type="text" class="form-control" id="authors" name="authors" value="{$authors|escape}">
					</div>
					<div class="form-group">
						<label for="dateFromYear">
							{translate key="search.dateFrom"}
						</label>
						<div>
							{html_select_date class="form-control" prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd year_empty="" month_empty="" day_empty="" field_order="YMD"}
						</div>
					</div>
					<div class="form-group">
						<label for="dateToYear">
							{translate key="search.dateTo"}
						</label>
						<div>
							{html_select_date class="form-control" prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd year_empty="" month_empty="" day_empty="" field_order="YMD"}
						</div>
					</div>
					<div class="form-group">
						<button class="btn btn-primary" type="submit">{translate key="common.search"}</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
