export enum Status {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  PENDING = 'pending',
  DELETED = 'deleted',
}


export enum OrderStatus {
  PENDING = 'pending',
  UNPAID = 'unpaid',
  PAID = 'paid',
  CANCEL = 'cancel',
  COMPLETED = 'completed',
  RETURN = 'return'
}

export enum OrderItemStatus {
  ACTIVE = 'ACTIVE',
  RETURNED = 'RETURNED'
}

export enum StockStatus {
  IN_STOCK = 'InStock',
  OUT_OF_STOCK = 'OutOfStock'

}