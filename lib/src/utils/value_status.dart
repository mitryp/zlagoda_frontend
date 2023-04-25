enum ValueChangeStatus {
  notChanged,
  updated,
  created,
  deleted;
}

class ValueStatusWrapper<T> {
  final T? value;
  ValueChangeStatus status;

  ValueStatusWrapper(this.status, [this.value]);

  ValueStatusWrapper.notChanged()
      : status = ValueChangeStatus.notChanged,
        value = null;

  ValueStatusWrapper.updated(T this.value) : status = ValueChangeStatus.updated;

  ValueStatusWrapper.created(T this.value) : status = ValueChangeStatus.created;

  ValueStatusWrapper.deleted()
      : status = ValueChangeStatus.deleted,
        value = null;

  bool get hasValue => value != null;
}
