import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_jiriki/features/select_contacts/repository/select_contacts_repository.dart';

final getContactsProvider = FutureProvider<List<Contact>>((ref) {
  final selectContactRepository = ref.read(selectContactsRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactsControllerProvider = Provider(
  (ref) {
    final selectsContactsRepository =
        ref.read(selectContactsRepositoryProvider);
    return SelectsContactsController(
      selectsContactsRepository: selectsContactsRepository,
      ref: ref,
    );
  },
);

class SelectsContactsController {
  final SelectsContactsRepository selectsContactsRepository;
  final ProviderRef ref;

  SelectsContactsController({
    required this.selectsContactsRepository,
    required this.ref,
  });

  void selectContacts(
    Contact selectedContact,
  ) {
    ref.read(selectContactsRepositoryProvider).selectContacts(selectedContact);
  }
}
