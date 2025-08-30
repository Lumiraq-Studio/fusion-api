export interface PaginationResponse<T> {
  page: number
  itemsPerPage: number
  totalItems: number
  data: T
}
