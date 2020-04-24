{**
 * templates/frontend/components/navigationMenu.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Primary navigation menu list for OJS
 *
 * @uses navigationMenu array Hierarchical array of navigation menu item assignments
 * @uses id string Element ID to assign the outer <ul>
 * @uses ulClass string Class name(s) to assign the outer <ul>
 * @uses liClass string Class name(s) to assign all <li> elements
 *}

{if $navigationMenu}
	<ul id="{$id|escape}"{if $id==="navigationPrimary"} class="navbar-nav"{/if}>
		{foreach key=field item=navigationMenuItemAssignment from=$navigationMenu->menuTree}
			{if !$navigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
				{continue}
			{/if}

			{* Check if menu item has submenu *}
			{if $navigationMenuItemAssignment->navigationMenuItem->getIsChildVisible()}
				{assign var=hasSubmenu value=true}
			{else}
				{assign var=hasSubmenu value=false}
			{/if}
			<li class="{$navigationMenuItemAssignment->navigationMenuItem->getType()|lower} main-menu__nav-item{if $hasSubmenu} dropdown{/if} {pragma_item_active item=$navigationMenuItemAssignment->navigationMenuItem}">
				<a class="main-menu__nav-link"
				   href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}" {if $hasSubmenu} role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"{/if}>
					<span{if $hasSubmenu} class="dropdown-toggle"{/if}>{$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}</span>
				</a>
				{if $hasSubmenu}
					<ul class="dropdown-menu{if $id==="navigationUser"} dropdown-menu-right{/if}">
						{foreach key=childField item=childNavigationMenuItemAssignment from=$navigationMenuItemAssignment->children}
							{if $childNavigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
								<li class="{$liClass|escape} dropdown-item">
									<a href="{$childNavigationMenuItemAssignment->navigationMenuItem->getUrl()}">
										{$childNavigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
									</a>
								</li>
							{/if}
						{/foreach}
					</ul>
				{/if}
			</li>
		{/foreach}
	</ul>
{/if}
