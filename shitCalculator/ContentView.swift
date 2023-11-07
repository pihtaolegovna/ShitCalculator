import SwiftUI
import SwiftData

struct EditItemView: View {
    @State private var newTimestamp: Date
    @State private var newAmount: Int
    let item: Item
    let editItem: (Item, Date, Int) -> Void

    init(item: Item, editItem: @escaping (Item, Date, Int) -> Void) {
        self._newTimestamp = State(initialValue: item.timestamp)
        self._newAmount = State(initialValue: item.amount)
        self.item = item
        self.editItem = editItem
    }

    var body: some View {
        VStack {
            DatePicker("Посрал в", selection: $newTimestamp, displayedComponents: [.date, .hourAndMinute])
            TextField("Edit Amount", value: $newAmount, formatter: NumberFormatter())
            Button("Save") {
                editItem(item, newTimestamp, newAmount)
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: EditItemView(item: item, editItem: editItem)) {
                        Text("Я ПОСРАЛ: \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard)) Amount: \(item.amount)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date(), amount: 0) // Initialize the amount property
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func editItem(item: Item, newTimestamp: Date, newAmount: Int) {
        withAnimation {
            item.timestamp = newTimestamp
            item.amount = newAmount
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: Item.self, inMemory: true)
    }
}
#endif
