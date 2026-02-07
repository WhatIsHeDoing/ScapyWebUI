# """Scapy UI integration tests."""
from playwright.sync_api import Page, expect


def init(page: Page):
    page.goto("http://127.0.0.1:5000")
    expect(page).to_have_title("Scapy Web UI")


def test_invalid_domain(page: Page):
    init(page)
    page.get_by_role("button", name="Search").click()

    expect(
        page.get_by_text("Oops, there was a problem with that domain.")
    ).to_be_visible()

    page.screenshot(path="screenshots/test_invalid_domain.png", full_page=True)


def test_valid_domain(page: Page):
    init(page)
    page.get_by_label("Domain").fill("darrenhickling.com")
    page.get_by_role("button", name="Search").click()

    expect(page.locator("#table tbody")).to_be_visible(timeout=30000)
    page.screenshot(path="screenshots/test_valid_domain.png", full_page=True)
