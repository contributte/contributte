<?php declare(strict_types=1);

namespace Nette\Utils;


/**
 * Paginating math.
 */
class Paginator
{
	public const
		Priority = 'priority',
		Expire = 'expire';

	#[\Deprecated('use Paginator::Priority')]
	public const PRIORITY = self::Priority;

	private int $page = 1;
	private int $itemsPerPage = 1;

	/** @var array<string, int>  service name => index */
	private array $index = [];


	public function __construct(
		private readonly Storage $storage,
		private readonly ?string $namespace = null,
	) {
	}


	/**
	 * Sets current page number.
	 */
	public function setPage(int $page): static
	{
		$this->page = $page;
		return $this;
	}


	private function checkRange(int $page): bool
	{
		return $page >= 1 && $page <= $this->getPageCount();
	}
}
