{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Site index page.
 *
 *}
{include file="frontend/components/header.tpl" immersionIndexType="indexSite"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				{if $about}
					<div>
						{$about|strip_unsafe_html|nl2br}
					</div>
				{/if}
				<h2 class="main__title">
					{translate key="journal.journals"}
				</h2>
			</header>

			<div>
				{if !count($journals)}
					{translate key="site.noJournals"}
				{else}
					<ul>
						{iterate from=journals item=journal}
							{capture assign="url"}{url journal=$journal->getPath()}{/capture}
							{assign var="thumb" value=$journal->getLocalizedSetting('journalThumbnail')}
							{assign var="description" value=$journal->getLocalizedDescription()}
							<li>
								{if $thumb}
									<div>
										<a href="{$url|escape}">
											<img src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}"{if $thumb.altText} alt="{$thumb.altText|escape}"{/if}>
										</a>
									</div>
								{/if}

								<h3>
									<a href="{$url|escape}" rel="bookmark">
										{$journal->getLocalizedName()}
									</a>
								</h3>
								{if $description}
									<div>
										{$description|nl2br}
									</div>
								{/if}
								<p>
									<a class="btn btn-primary"  href="{$url|escape}">
										{translate key="site.journalView"}
									</a>
									<a class="btn btn-secondary" href="{url|escape journal=$journal->getPath() page="issue" op="current"}">
										{translate key="site.journalCurrent"}
									</a>
								</p>
							</li>
						{/iterate}
					</ul>

					{if $journals->getPageCount() > 0}
						<div>
							{page_info iterator=$journals}
							{page_links anchor="journals" name="journals" iterator=$journals}
						</div>
					{/if}
				{/if}
			</div>
		</div>
	</div><!-- .row -->

</main><!-- .page -->

{include file="frontend/components/footer.tpl"}
